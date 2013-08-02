jQuery ->
	$("#more_status_comments").click (e) ->
		e.preventDefault()
		url = $(".pagination ul > li:last-child > a").attr("href")
		$.getScript(url) if url
		
	dynamicStatusInit()

window.dynamicStatusInit = ->
	$("#status_submit").attr("disabled", false)
	urlRegex = /(https?:\/\/|www)[\S]+/i

	$("#status_content").keyup (e) ->
		content_value = $("#status_content").attr("value")
		url = urlToScrape( content_value ) if e.keyCode is 32
		unless attachmentAlreadyPresent()
			scrapeAndSortAttachment( url ) if url

	$("#status_content").bind "paste", (e) ->
		setTimeout (->
			content_value = $("#status_content").attr("value")
			url = urlToScrape( content_value )
			unless attachmentAlreadyPresent()
				scrapeAndSortAttachment( url ) if url
		), 100

	$("a.clear-attached-link").click (e) ->
  		clearAttachedLink()
  		e.preventDefault()

  	$("p#check_no_thumb input:checkbox").live "change", ->
  	  showOrHideThumbs(this)

  	$("#status_form").on  "click", "#uploadPhotoLink", (e) ->
  		$(".uploadPic").click()
  		e.preventDefault()


  	$(".uploadPic").change ->
  		file = $(".uploadPic").val()
  		if file
	  		short_file = file.split("\\").slice(-1)[0]
	  		$("#uploadPhotoLink .desc").text(short_file)
	  	else
	  		("#uploadPhotoLink .desc").text('Add a photo')

	$box_closed = true
	$("#status_form").on "click", "#status_content", (e) ->
		while $box_closed is true
			$("#extraStatus").collapse('show')
			$box_closed = false
			$("#status_submit").attr("disabled", false)

	$("#status_tag_list").tagit
		placeholderText: "Add some tags"
	$("#status_share_list").tagit
		placeholderText: "Share by username or email"

	$(".shareStatusLink").click (e) ->
		e.preventDefault()
		tags = $("#shareStatus").find("ul.tagit")
		input = $("#shareStatus").find("input#status_share_list")
		$(tags).css("width", input.width())
		$(tags).css("float", "left")

	$("#shareStatus").on "shown", ->
		$(".shareStatusLink").attr("data-toggle", "")

	$(".addVideoStatusLink").click (e) ->
		e.preventDefault()
		enableStatusVideo()
		bindVideoUploadEvents()

enableStatusVideo = ->
	pandaJson = $('.status_video').data('auth')
	$(".status_video #returned_video_id").pandaUploader pandaJson,
		upload_progress_id: "upload_progress_status"

bindVideoUploadEvents = ->
	video_upload = $(".status_video input#returned_video_id").next("input")
	$("#status_form").on "click", "#uploadStatusVideoLink", (e) ->
		$(video_upload).click()
		e.preventDefault()

	$(video_upload).change ->
  		file = $(this).val()
  		if file
	  		short_file = file.split("\\").slice(-1)[0]
	  		$("#uploadStatusVideoLink").text(short_file)
	  	else
	  		("#uploadStatusVideoLink").text('Upload')

	$("#status_submit").attr("disabled", false)

showOrHideThumbs = (obj) ->
	if $(obj).is(":checked")
		$("#image_choices_total").hide()
		$("#url_image_choices").hide()
		$("#atc_total_image_nav").hide()
		$("#atc_total_images_info").hide()
		$("#status_attached_url_image").val ""
		$("#check_no_thumb").hide()

clearAttachedLink = () ->
	$("#link_title").empty()
	$("#link_desc").empty()
	$("#link_url").empty()
	$("#url_image_choices").empty()
	$("#external_link_content").hide()
	clearFormValues()

urlToScrape = (content) ->
	urlRegex = /(https?:\/\/|www)[\S]+/i
	matches = content.match(urlRegex)
	unless matches
		false
	else
		matches[0].split(' ')[0]



scrapeAndSortAttachment = (url) ->
	$("#link-loading").show()
	$("#ajax_fetch_error").hide()
	if isYoutubeLink(url)
		processYoutubeAttachment(url)
	else
		$.ajax
			type: "GET"
			url: "/status_search_url?" + "url=" + url
			dataType: "json"
			processData: false
			contentType: "json"
			error: ->
				$("#link-loading").hide()
				$("#ajax_fetch_error").show()
			success: (response) ->
				$("#link-loading").hide()
				$("#external_link_content").show()
				$("#link_title").html response.title
				$("#link_desc").html response.description
				$("#link_url").html response.full_url
				if response.total_images < 1
					$("#image_choices_total").hide()
					$("#url_image_choices").hide()
					$("#atc_total_image_nav").hide()
					$("#atc_total_images_info").hide()
				else
					$("#image_choices_total").html response.total_images
					$("#url_image_choices").html " "
					$.each response.images, (a, b) ->
						$("#url_image_choices").append "<img src=\"" + b + "\" width=\"100\" id=\"" + (a + 1) + "\">"

					$("#url_image_choices img").hide()
					$("img#1").show()
					$("#visible_image").val 1
					$("#visible_image_num").html 1
					setFormValues(response.full_url, "img#1", response.title, response.description)

					$("#next").click (e) ->
						total_images = parseInt($("#image_choices_total").html())
						if total_images > 0
							index = $("#visible_image").val()
							$("img#" + index).hide()
							if index < total_images
								new_index = parseInt(index) + parseInt(1)
							else
								new_index = 1
							populateNewImage(new_index)
						e.preventDefault()

					$("#prev").click (e) ->
						total_images = parseInt($("#image_choices_total").html())
						if total_images > 0
							index = $("#visible_image").val()
							$("img#" + index).hide()
							if index > 1
								new_index = parseInt(index) - parseInt(1)
							else
								new_index = total_images
							populateNewImage(new_index)
						e.preventDefault()

isYoutubeLink = (url) ->
	youtubeRegex = /https?:\/\/(www.)?(youtube\.com\/watch\?v=|youtu\.be\/|youtube\.com\/watch\?feature=player_embedded&v=)([A-Za-z0-9_-]*)(\&\S+)?(\S)*/
	matches = url.match(youtubeRegex)
	true if matches

processYoutubeAttachment = (url) ->
	$("#link-loading").hide()
	$("#statusVideoFooter input[type=text]").val(url)

attachmentAlreadyPresent = ->
	$("#external_link_content").is(":visible")

populateNewImage = (new_index) ->
	$("#visible_image").val new_index
	$("#visible_image_num").html new_index
	new_image = $("img#" + new_index)
	new_image.show()
	$("#status_attached_url_image").val $(new_image).attr("src")

setFormValues = (url, img, title, desc) ->
	$("#status_attached_url").val url
	$("#status_attached_url_image").val $(img).attr("src")
	$("#status_attached_url_title").val title
	$("#status_attached_url_description").val desc

clearFormValues = ->
	$("#status_attached_url").val ""
	$("#status_attached_url_image").val ""
	$("#status_attached_url_title").val ""
	$("#status_attached_url_description").val ""



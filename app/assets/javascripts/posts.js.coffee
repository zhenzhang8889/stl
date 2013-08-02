jQuery ->
	$('form').on 'click', '#post_submit', (event) ->
		$("#link-loading.post").css("display", "inline")

	$("#more_post_comments").click (e) ->
		e.preventDefault()
		url = $(".pagination ul > li:last-child > a").attr("href")

		$.getScript(url) if url

	$("#post_tag_list").tagit
		placeholderText: "Add some tags"

	$("#post_share_list").tagit
		placeholderText: "Share by username or email"

	$(".sharePostLink").click (e) ->
		e.preventDefault()
		tags = $("#sharePost").find("ul.tagit")
		input = $("#sharePost").find("input#post_share_list")
		$(tags).css("width", input.width())
		$(tags).css("float", "left")

	$("#sharePost").on "shown", ->
		$(".sharePostLink").attr("data-toggle", "")
	
	$("#post_submit").attr("disabled", false)

	$("#article_new_form").on "click", "#postUploadPhotoLink", (e) ->
		e.preventDefault()
		$(".uploadPostPic").click()

	$(".uploadPostPic").change ->
		file = $(".uploadPostPic").val()
		if file
			short_file = file.split("\\").slice(-1)[0]
			$("#postUploadPhotoLink .desc").text(short_file)
		else
			("#postUploadPhotoLink .desc").text('Add a photo')

	$("#article_new_form").on "click", "a.addVideoPostLink", (e) ->
		e.preventDefault()
		enablePostVideo()
		bindPostVideoUploadEvents()

enablePostVideo = ->
	pandaJson = $('.post_video').data('auth')
	$(".post_video #returned_video_id").pandaUploader pandaJson,
		upload_progress_id: "upload_progress_post"

bindPostVideoUploadEvents = ->
	post_video_upload = $(".post_video input#returned_video_id").next("input")
	$("#article_new_form").on "click", "#uploadPostVideoLink", (e) ->
		e.preventDefault()
		$(post_video_upload).click()

	$(post_video_upload).change ->
		file = $(this).val()
		if file
			short_file = file.split("\\").slice(-1)[0]
			$("#uploadPostVideoLink").text(short_file)
		else
			("#uploadPostVideoLink").text('Upload')

	$(".hiddenPanda").css
		left:"-10000px"
		top:"auto"
		width:"1px"
		height:"1px"
		overflow:"hidden"

	$("#post_submit").attr("disabled", false)

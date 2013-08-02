jQuery ->
	comment_height = $("#comment_content").height()
	$(".new_comment").live "keydown", (e) ->
		keyCode = e.keyCode or e.which
		if keyCode is 13
			$(this).submit()

	$('.dev').click (e) ->
		alert "In development"
		e.preventDefault()

	$('.drop_comments').click (e) ->
		list = $(this).data("target")
		$(list).collapse('toggle')
		last_comment = $(this).closest(".box").find(".last_comment")
		$(last_comment).hide()
		e.preventDefault()

	$('.comment_list').on 'shown', (e) ->
		reloadIsotope()

	$('.comment_list').on 'hidden', (e) ->
		reloadIsotope()
	
	$(".live_comment").keyup (e) ->
		if $(this).height() > comment_height
  			reloadIsotope()

	$(".container").on "mouseenter", ".item", ->
	  $(this).find(".options").fadeIn()


	$(".container").on "mouseleave", ".item", ->
	  $(this).find(".options").fadeOut()


window.reloadIsotope = ->
	$("#feed_list").isotope
		transformsEnabled: false
		itemSelector: ".item"
		layoutMode: "masonry"

window.toggleSorting = (element) ->
	if $(element).hasClass("checked")
    $(element).attr("data-sort", "true")
  else
    $(element).attr("data-sort", "false")

  parentUl = $(element).closest("ul")
  contents = []
  $(parentUl).find("a").each (i,e) ->
    if $(e).attr("data-sort") == "true"
      contents.push($(e).data("content"))
  form = $(parentUl).find("form")
  hidden_field = $(form).find("#activity_content")
  $(hidden_field).val(contents)
  $(form).submit()

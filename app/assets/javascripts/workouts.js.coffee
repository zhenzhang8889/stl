# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/

$(document).ready ->
	bindExerciseEvents()
	bindWorkoutTags()
	bindWorkoutPhotoUpload()
	
	$("#workout_submit").attr("disabled", false)

	$('form').on 'click', '#workout_submit', (event) ->
		$("#link-loading.workout").css("display", "inline")

	$("#more_workout_comments").click (e) ->
		e.preventDefault()
		url = $(".pagination ul > li:last-child > a").attr("href")
		$.getScript(url) if url

	$(".shareWorkoutLink").click (e) ->
		e.preventDefault()
		tags = $("#shareWorkout").find("ul.tagit")
		input = $("#shareWorkout").find("input#workout_share_list")
		$(tags).css("width", input.width())
		$(tags).css("float", "left")

	$("#shareWorkout").on "shown", ->
		$(".shareWorkoutLink").attr("data-toggle", "")

	$(".add_fields").click()

	$("#workout_form").on "click", "a.addVideoWorkoutLink", (e) ->
		e.preventDefault()
		enableWorkoutVideo()
		bindWorkoutVideoUploadEvents()

bindWorkoutPhotoUpload = ->
	$("#workout_form").on "click", "#workoutUploadPhotoLink", (e) ->
		e.preventDefault()
		$(".uploadWorkoutPic").click()

	$(".uploadWorkoutPic").change ->
		file = $(".uploadWorkoutPic").val()
		if file
			short_file = file.split("\\").slice(-1)[0]
			$("#workoutUploadPhotoLink .desc").text(short_file)
		else
			("#workoutUploadPhotoLink .desc").text('Add a photo')

bindWorkoutTags = ->
	$("#workout_tag_list").tagit
		placeholderText: "Add some tags"

	$("#workout_share_list").tagit
		placeholderText: "Share by username or email"

bindExerciseEvents = ->
	$('form').on 'click', '.add_fields', (event) ->
		time = new Date().getTime()
		regexp = new RegExp($(this).data('id'), 'g')
		$(this).before($(this).data('fields').replace(regexp, time))
		event.preventDefault()
		
	$("#workout_new_form").live "DOMNodeInserted", (event) ->
		unique = Math.floor(
				   Math.random() * 0x10000
				 ).toString(16)
		newForm = $(event.target)
		newForm.find(".add-more-exercise").attr("href", "#" + unique)
		newForm.find(".collapse").attr("id", unique)

	$('form').on 'click', '.remove-exercise', (event) ->
		$(this).closest("#new-exercise-fieldset").remove()

	$('form').on 'click', '.add-more-exercise', (event) ->
		$(this).html("Tell us less <i class='icon-circle-arrow-right'></i>")
		$(this).addClass("add-less-exercise")
		$(this).removeClass("add-more-exercise")
		
	$('form').on 'click', '.add-less-exercise', (event) ->
		$(this).html("Tell us more <i class='icon-circle-arrow-right'></i>")
		$(this).addClass("add-more-exercise")
		$(this).removeClass("add-less-exercise")

	$('form').on 'click', '.clickExercisePhoto', (event) ->
		$(".exercisePhoto").click()
		event.preventDefault()

	$('form').on 'change', '.exercisePhoto', (event) ->
  		file = $(this).val()
  		if file
	  		short_file = file.split("\\").slice(-1)[0]
	  		$(".exercise_photo_name").text(short_file)

enableWorkoutVideo = ->
	pandaJson = $('.workout_video').data('auth')
	$(".workout_video #returned_video_id").pandaUploader pandaJson,
		upload_progress_id: "upload_progress_workout"

bindWorkoutVideoUploadEvents = ->
	workout_video_upload = $(".workout_video input#returned_video_id").next("input")
	$("#workout_form").on "click", "#uploadWorkoutVideoLink", (e) ->
		e.preventDefault()
		$(workout_video_upload).click()

	$(workout_video_upload).change ->
		file = $(this).val()
		if file
			short_file = file.split("\\").slice(-1)[0]
			$("#uploadWorkoutVideoLink").text(short_file)
		else
			("#uploadWorkoutVideoLink").text('Upload')

	$(".hiddenPanda").css
		left:"-10000px"
		top:"auto"
		width:"1px"
		height:"1px"
		overflow:"hidden"

	$("#workout_submit").attr("disabled", false)
		

	

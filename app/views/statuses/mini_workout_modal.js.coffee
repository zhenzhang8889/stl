$('#miniWorkoutModal .modal-body').html("<%= escape_javascript render(:partial => 'statuses/mini_workout_form', :locals => { :mini => @status }) %>")

$("#miniWorkoutModal").on "click", "#mini_options a.btn", (e) ->
	$("#mini_options a.btn").each (i,e) ->
		$(e).removeClass("active")
	$(this).addClass("active")
	new_type = $(this).attr("data-workout")
	$("#mini_options #status_mini_workout_type").val(new_type)

	$("#status_mini_workout_type_custom").keyup (e) ->
		$("#mini_options a.btn").each (i,e) ->
			$(e).removeClass("active")
		$("#mini_options #status_mini_workout_type").val("")

$("#miniWorkoutModal").on "click", "#mini_duration_options a.btn", (e) ->
	$("#mini_duration_options a.btn").each (i,e) ->
		$(e).removeClass("active")
	$(this).addClass("active")
	new_type = $(this).attr("data-duration")
	$("#mini_duration_options #status_duration").val(new_type)

	$("#status_duration_custom").keyup (e) ->
		$("#mini_duration_options a.btn").each (i,e) ->
			$(e).removeClass("active")
		$("#mini_duration_options #status_duration").val("")
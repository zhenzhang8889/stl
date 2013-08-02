jQuery ->
	$("#user_interest_list").tagit
		placeholderText: "Add some interests"

	$("#user_skill_list").tagit
		placeholderText: "Add some skills"

  $("#add_interests").on "click", "a.btn", (e) ->
    $(this).addClass("active")

  $(".container").on "click", "#filter_network a", (e) ->
    $("#filter_network a").each (i,e) ->
      $(e).removeClass("active")
    $(this).addClass("active")
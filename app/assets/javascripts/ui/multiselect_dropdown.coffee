$(document).ready ->
  # Multi select - allow multiple selections
  # Allow click without closing menu
  # Toggle checked state and icon 
  $("#feed").on "click", ".multicheck", (e) ->
    $(this).toggleClass "checked"
    toggleSorting(this)
    false
  
  # Single Select - allow only one selection
  # Toggle checked state and icon and also remove any other selections 
  $(".singlecheck").click (e) ->
    $(this).parent().siblings().children().removeClass "checked"
    $(this).toggleClass "checked"
    false
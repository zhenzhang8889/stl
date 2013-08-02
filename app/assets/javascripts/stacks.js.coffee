jQuery ->
  $("#tab-content").on "click", "#more_stack_comments", (e) ->
    e.preventDefault()
    url = $(".pagination ul > li:last-child > a").attr("href")
    $.getScript(url) if url 

# window.reloadStackIsotope = ->
#   $("#feed").isotope
#     transformsEnabled: false
#     itemSelector: ".item"
#     layoutMode: "masonry"
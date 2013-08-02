$(window).load ->
  $("#feed_list").isotope
    transformsEnabled: false
    itemSelector: ".item"
    layoutMode: "masonry"

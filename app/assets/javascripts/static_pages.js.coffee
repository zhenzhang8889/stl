 $(document).ready ->
  $(".goal_search").keyup ->
    $(".modal-header .title").html $(this).val()
    target_href = "/search/index?search_keyword=" + $(this).val().split(' ').join('-')
    $(".btn-inverse").attr "href", target_href
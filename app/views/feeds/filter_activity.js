<% if @search.present? %>
	$("#feed_contents").html("<%= j render(partial: 'feeds/feed_results', locals: { items: @results } ) %>");
<% else %>
	$("#feed_contents").html("<%= j render(partial: 'feeds/feed_results', locals: { items: @feed_items } ) %>");
<% end %>
reloadIsotope();
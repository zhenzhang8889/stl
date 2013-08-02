jQuery ->
	unless $(".notify_ids").length == 0
		$(".notify_menu a").click (e) ->
			$.ajax
			    type: "PUT"
			    url: "/notifications/viewed"
			    data: "ids=" + $("ul .notify_ids").data("ids")
			    dataType: "script"
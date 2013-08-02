# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/
jQuery ->   
  # validate of the feedback sending form
  $("#messages_frm").validate 
    rules: { body: { required: true } },
    messages: { body: "Please input your message contents!" },
    submitHandler: (form) ->
      $.ajax 
        url: $(form).attr("action") 
        type: 'GET'
        data: $(form).serialize()
        success: (data, textStatus, jqXHR ) ->        
          $("#message_in_modal").modal('hide')        
          $("#msg_success_in_modal").modal('show')
          
          setTimeout ->
            $("#msg_success_in_modal").modal('hide')
          , 2000          
          return
  
  $("#sending_frm").validate 
    rules: { body: { required: true }, recipients: { required: true} },
    messages: { body: "Please input your message contents!", recipients: "Please select the recipient!" }
     
            
  $("#composes_frm").validate 
    rules: { body: { required: true  }, recipients: { required: true } },
    messages: { body: "Please input your message contents!", recipients: "Can't empty!" },
    submitHandler: (form) ->
      $.ajax 
        url: $(form).attr("action") 
        type: 'GET'
        data: $(form).serialize()
        success: (data, textStatus, jqXHR ) ->        
          $("#compose_in_modal").modal('hide')        
          $("#msg_success_in_modal").modal('show')
          
          setTimeout ->
            $("#msg_success_in_modal").modal('hide')
          , 2000          
          return
  
  $(".container").on "click", "#user_list a", (e) ->
    $("#user_list a").each (i,e) ->
      $(e).removeClass("active")
    $(this).addClass("active")
    
  return 
  
  
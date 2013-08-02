# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/
jQuery ->  
  # validate of the feedback sending form
  $("#feedback_frm").validate 
    rules: { from: { required: true, email: true}, name: {required: true}, contents: { required: true } },
    messages: { from: { required: "We need your email address to contact you", email: "Your email address must be in the format of name@domain.com"}, name: "Please input your name!", contents: "What do you think of this site?" },
    submitHandler: (form) ->
      $.ajax 
        url: $(form).attr("action") 
        type: 'GET'
        data: $(form).serialize()
        success: (data, textStatus, jqXHR ) ->        
          $("#feedback_in_modal").modal('hide')        
          $("#success_in_modal").modal('show')
          
          setTimeout ->
            $("#success_in_modal").modal('hide')
          , 2000          
          return
  return     
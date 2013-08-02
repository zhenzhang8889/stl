# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/

$(document).ready ->
  bindServicePhotoUpload()
  
  $("#service_spots").spinner({min:0, max:3})
  
  $(".jquery-ui-date").datepicker(
    altField: "#service_expiration_date",
    altFormat: "yy-mm-d"
  )   
    
  $("#service_tag_list").tagit
    placeholderText: "Add some tags"
  
  $(".shareServiceLink").click (e) ->
    e.preventDefault()
    tags = $("#shareService").find("ul.tagit")
    input = $("#shareService").find("input#service_share_list")
    $(tags).css("width", input.width())
    $(tags).css("float", "left")
  
  $("#service_new_form").on "click", "a.addVideoServiceLink", (e) ->
    e.preventDefault()
    enableServiceVideo()
    bindServiceVideoUploadEvents()
     
  $("#service_new_form").validate ->
    rules: { description: { require: true; }}
    submitHandler: (form) ->
      $promotion = $(form).find('input[name="promotion"]:checked')
      if !$promotion.length
        alert("asdfasdf")    
        return false
      else
        $("#link-loading.service").css("display", "inline")
        return true  
    
enableServiceVideo = ->
  pandaJson = $('.service_video').data('auth')
  $(".service_video #returned_video_id").pandaUploader pandaJson,
    upload_progress_id: "upload_progress_service"
        
bindServiceVideoUploadEvents = ->
  service_video_upload = $(".service_video input#returned_video_id").next("input")
  $("#service_form").on "click", "#uploadServiceVideoLink", (e) ->
    e.preventDefault()
    $(service_video_upload).click()

  $(service_video_upload).change ->
    file = $(this).val()
    if file
      short_file = file.split("\\").slice(-1)[0]
      $("#uploadServiceVideoLink").text(short_file)
    else
      ("#uploadServiceVideoLink").text('Upload')
   
  
  $(".hiddenPanda").css
      left:"-10000px"
      top:"auto"
      width:"1px"
      height:"1px"
      overflow:"hidden"   
      
  return
       
bindServicePhotoUpload = -> 
  $("#service_form").on "click", "#serviceUploadPhotoLink", (e) ->
    e.preventDefault()
    $(".uploadServicePic").click()
    
  $(".uploadServicePic").change ->
    file = $(".uploadServicePic").val()
    if file
      short_file = file.split("\\").slice(-1)[0]
      $("#serviceUploadPhotoLink .desc").text(short_file)
    else
      ("#serviceUploadPhotoLink .desc").text('Add a photo')   
  return
  
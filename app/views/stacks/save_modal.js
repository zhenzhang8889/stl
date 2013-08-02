$('#saveToStackModal .modal-body').html("<%= escape_javascript render(:partial => 'stacks/save_to', :locals => { :content => @content }) %>");
$('#stacks').chosen();

$("form").on("click", ".submit_save", function(e) {
  $("#saveFade").show();
  $("#saveFade p#link-loading").show();
  $("#saveFade #success").hide();
  $("#add_errors ul").empty();
  $("#add_errors").hide();
});

$('#saveToStackModal').on('hidden', function () {
  $("#saveFade").hide();
  $("#saveFade p#link-loading").hide();
  $("#saveFade #success").hide();
  $('#saveToStackModal .modal-body').empty();
});
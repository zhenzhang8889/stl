$('#tab-content').html("<%= escape_javascript render(:file => 'stacks/comments', :formats => [:html]) %>");
reloadIsotope()
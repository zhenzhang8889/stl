$('#tab-content').html("<%= escape_javascript render(:file => 'stacks/following', :formats => [:html]) %>");
reloadIsotope()
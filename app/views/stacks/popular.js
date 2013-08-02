$('#tab-content').html("<%= escape_javascript render(:file => 'stacks/popular', :formats => [:html]) %>");
reloadIsotope()
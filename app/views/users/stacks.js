$('#tab-content').html("<%= escape_javascript render(:file => 'users/stacks', :formats => [:html]) %>");
reloadIsotope()
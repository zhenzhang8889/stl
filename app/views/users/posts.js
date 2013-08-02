$('#tab-content').html("<%= escape_javascript render(:file => 'users/posts', :formats => [:html]) %>");
reloadIsotope()
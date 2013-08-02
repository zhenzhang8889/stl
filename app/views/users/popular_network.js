$('#tab-content').html("<%= escape_javascript render(:file => 'users/popular_network', :formats => [:html]) %>");
reloadIsotope()
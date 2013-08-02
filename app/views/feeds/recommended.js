$('#tab-content').html("<%= escape_javascript render(:file => 'feeds/recommended', :formats => [:html]) %>");
reloadIsotope()
$('#tab-content').html("<%= escape_javascript render(:file => 'feeds/featured', :formats => [:html]) %>");
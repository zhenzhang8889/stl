$('#tab-content').html("<%= escape_javascript render(:file => 'users/services', :formats => [:html]) %>");
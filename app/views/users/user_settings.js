$('#tab-content').html("<%= escape_javascript render(:file => 'devise/registrations/edit', :formats => [:html]) %>");
$('#tab-content').html("<%= escape_javascript render(:file => 'stacks/items', :formats => [:html]) %>");
reloadIsotope()
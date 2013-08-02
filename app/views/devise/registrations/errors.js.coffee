<% if params[:profile_settings] %>
	$('#tab-content').html("<%= escape_javascript render(:file => 'users/profile_settings', :formats => [:html]) %>")
<% elsif params[:user_settings] %>
	$('#tab-content').html("<%= escape_javascript render(:file => 'devise/registrations/edit', :formats => [:html]) %>")
<% end %>

class NotificationMailer < ActionMailer::Base
  add_template_helper(NotificationsHelper)

  default from: "messages@surpassthelimit.com"

  def notify_for_comment_on_content(n)
    @n = n
    @user = n.user
    @comment = n.notifiable

    mail(:to => @n.email, :subject => "New Comment")
  end

  def notify_for_comment_on_same_content(n)
    @n = n
    @user = n.user
    @comment = n.notifiable

    mail(:to => @n.email, :subject => "New Comment")
  end

  def notify_for_like_comment(n)
    @n = n
    @user = n.user
    @l = n.notifiable

    mail(:to => @n.email, :subject => "New Like")
  end

  def notify_for_like_content(n)
    @n = n
    @user = @n.user
    @content = @n.notifiable

    mail(to: @n.email, subject: "New Like")
  end

  def notify_for_follow(n)
    @n = n
    @user = n.user
    @r = n.notifiable

    mail(:to => @n.email, :subject => "You have a new follower")
  end

  def notify_for_follow_stack(n)
    @n = n
    @user = n.user
    @s = n.notifiable

    mail(:to => @n.email, :subject => "You have a new stack follower")
  end

  def notify_for_share(n)
    @n = n
    @user = n.user
    @c = n.notifiable

    mail(:to => @n.email, :subject => "#{@n.notifier} shared something with you")
  end

  def notify_for_compliment(n)
  	@n = n
    @user = n.user
  	@c = n.notifiable

  	mail(:to => @n.email, :subject => "You have been complimented")
  end

end

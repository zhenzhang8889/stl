# == Schema Information
#
# Table name: notifications
#
#  id              :integer         not null, primary key
#  email           :string(255)
#  created_at      :datetime        not null
#  updated_at      :datetime        not null
#  user_id         :integer
#  notify_method   :string(255)
#  notified        :boolean         default(FALSE)
#  notifiable_id   :integer
#  notifiable_type :string(255)
#  viewed          :boolean
#

class Notification < ActiveRecord::Base
  attr_accessible :email, :notify_method, :notified, :user_id, :viewed, :behaviour, :notifier_id

  scope :unviewed, where(:viewed => nil)
  scope :for_site, where(:notify_method => :site)

  belongs_to :user
  belongs_to :notifiable, polymorphic: true

  validates_presence_of :user_id

  def self.create_and_delegate(notifier, resource, user, behaviour, methods)
    methods.each do |m|
      notification = resource.notifications.create!(
        :notifier_id => notifier.id,
        :user_id => user.id,
        :notify_method => m,
        :email => user.email,
        :behaviour => behaviour
      )

      notification.send("notify_by_#{m}".to_sym)
    end
  end

  def self.check_validity(user)
    user.notifications.for_site.each do |n|
      n.delete if n.notifiable.nil?
      case n.notifiable.class.table_name
      when "comments"
        n.delete if n.notifiable.commentable.nil?
      when "likes"
        n.delete if n.notifiable.likeable.nil?
      end
    end
  end

  def notify_by_email
    send_for_email_and_deliver
    toggle_notified
  end

  def notify_by_site
    toggle_notified
  end

  def toggle_notified
    toggle!(:notified)
  end

  def send_for_email_and_deliver
    # class_name = self.notifiable_type.downcase
    # notification_method = "notify_for_#{class_name}"
    notification_method = "notify_for_#{self.behaviour}"
  	NotificationMailer.send(notification_method.to_sym, self).deliver
  end

  def notifier
    User.find(self.notifier_id)
  end
end

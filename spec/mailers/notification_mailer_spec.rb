require "spec_helper"

describe NotificationMailer do

  describe "#notify_for_comment_on_content" do
    let(:p) { create(:post) }
    let(:c) { create(:comment, commentable_id: p.id, commentable_type: "Post" ) }
    let(:n) { create(:email_notification,
                behaviour: :comment_on_content, 
                notifiable_id: c.id, 
                notifiable_type: "Comment", 
                user_id: c.commentable.user.id) }
    let(:m) { n.send_for_email_and_deliver }

    subject { m }

    its(:subject) { should eq "comment_on_content story" }
  end

  describe "#notify_for_comment_on_same_content" do
    xit "works" do
    end
  end

  describe "#notify_for_like_comment" do
    let(:p) { create(:post) }
    let(:l) { create(:like, likeable_id: p.id, likeable_type: "Post" ) }
    let(:n) { create(:email_notification,
                behaviour: :like_comment, 
                notifiable_id: l.id, 
                notifiable_type: "Like", 
                user_id: l.likeable.user.id) }
    let(:m) { n.send_for_email_and_deliver }

    subject { m }

    its(:subject) { should eq "like_comment story" }
  end

  describe "#notify_for_like_content" do
    let(:p) { create(:post) }
    let(:l) { create(:like, likeable_id: p.id, likeable_type: "Post" ) }
    let(:n) { create(:email_notification,
                behaviour: :like_content, 
                notifiable_id: l.id, 
                notifiable_type: "Like", 
                user_id: l.likeable.user.id) }
    let(:m) { n.send_for_email_and_deliver }

    subject { m }

    its(:subject) { should eq "like_content story" }
  end

  describe "#notify_for_follow" do
    let(:r) { create(:relationship) }
    let(:n) { create(:email_notification,
                behaviour: :follow, 
                notifiable_id: r.id, 
                notifiable_type: "Relationship", 
                user_id: r.followed.id) }
    let(:m) { n.send_for_email_and_deliver }

    subject { m }

    its(:subject) { should eq "You have a new follower" }
    # its(:to) { should eq [ n.email ] }
    # its(:body) { should =~ /is now following you!/ }
    # its(:body) { should include(n.user.name) }
    # its(:body) { should include(r.follower.name) }
  end

  describe "#notify_for_share" do
    xit "works" do
    end
  end

  describe "#notify_for_compliment" do
    let(:u) { create(:user) }
    let(:c) { create(:compliment, motivator: u) }
    let(:n) { create(:email_notification, 
                behaviour: :compliment,
                notifiable_id: c.id, 
                notifiable_type: "Compliment", 
                user_id: c.user.id) }
    let(:m) { n.send_for_email_and_deliver }

    subject { m }
    
    its(:subject) { should eq "You have been complimented" }
    # its(:to) { should eq [ n.email ] }
    # its(:body) { should =~ /gave you some/ }
    # its(:body) { should include(n.user.name) }
    # its(:body) { should include(c.motivator.name) }
  end
end


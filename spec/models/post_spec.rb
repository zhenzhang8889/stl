# == Schema Information
#
# Table name: posts
#
#  id             :integer         not null, primary key
#  name           :string(255)
#  link           :string(255)
#  body           :text
#  created_at     :datetime        not null
#  updated_at     :datetime        not null
#  user_id        :integer
#  comments_count :integer         default(0), not null
#  likes_count    :integer         default(0), not null
#

require 'spec_helper'

describe Post do
  
  let(:post) { create(:post) }
  subject { post }
  
  describe "validations" do
	  it { should validate_presence_of(:name) }
	  it { should validate_presence_of(:body) }
	end
  
  describe "associations" do
		it { should belong_to(:user) }
		it { should have_many(:comments) }
    it { should have_many(:feeds) }
  end
  
  describe "images and videos" do
		xit { should have_attached_file(:image) }
		xit { should have_attached_file(:post_video) }
  end
  
  describe "normalize file names after upload" do
    
    xit "should have the same name of uploaded video" do
      post.post_video_file_name.should eq "sample_mpeg4.mp4"
    end  
  
    xit "should normalize the file name after the image is uploaded" do
      @post = FactoryGirl.build(:post) 
      @post.image_file_name.should eq "#{@post.id}picture004.jpg"
    end
  
  end
  
end

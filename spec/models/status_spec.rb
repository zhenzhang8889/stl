# == Schema Information
#
# Table name: statuses
#
#  id                       :integer         not null, primary key
#  user_id                  :integer
#  created_at               :datetime        not null
#  updated_at               :datetime        not null
#  content                  :text
#  attached_url_image       :string(255)
#  attached_url             :string(255)
#  attached_url_description :string(255)
#  attached_url_title       :string(255)
#  comments_count           :integer         default(0), not null
#  likes_count              :integer         default(0), not null
#

require 'spec_helper'

describe Status do
	let(:status) { create(:status) }
	subject { status }

	describe "validations" do
		it { should validate_presence_of(:user_id) }
		it { should validate_presence_of(:content) }
	end

	describe "associations" do
		it { should belong_to(:user) }
		it { should have_many(:comments) }
		it { should have_many(:feeds) }
	end

	describe "images and videos" do
		xit { should have_attached_file(:pic) }
		xit { should have_attached_file(:status_video) }
	end

	describe "instance methods" do
		it { should respond_to(:has_attached_link?) }
		it { should respond_to(:has_attached_thumbnail?) }
	end
end

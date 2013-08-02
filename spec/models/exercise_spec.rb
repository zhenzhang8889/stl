# == Schema Information
#
# Table name: exercises
#
#  id                 :integer         not null, primary key
#  name               :string(255)
#  reps               :integer
#  weight             :float
#  equipment          :string(255)
#  description        :text
#  image_file_name    :string(255)
#  image_content_type :string(255)
#  image_file_size    :integer
#  image_updated_at   :datetime
#  video_file_name    :string(255)
#  video_content_type :string(255)
#  video_file_size    :integer
#  video_updated_at   :datetime
#  workout_id         :integer
#  created_at         :datetime        not null
#  updated_at         :datetime        not null
#

require 'spec_helper'

describe Exercise do
  let(:exercise) { create(:exercise) }
  subject { exercise }

  describe "state" do
	it { should be_valid }
  end

  describe "model attributes" do
	it { should respond_to(:name) }
	it { should respond_to(:reps) }
	it { should respond_to(:weight) }
	it { should respond_to(:equipment) }
	it { should respond_to(:description) }
	it { should respond_to(:image) }
	it { should respond_to(:video) }
  end

  describe "associations" do
	it { should belong_to(:workout) }
  end

  describe "validations" do
	it { should validate_presence_of(:name) }
	it { should validate_presence_of(:reps) }
	it { should validate_numericality_of(:reps) }
  end

  describe "images and videos" do
	it { should have_attached_file(:image) }
	it { should have_attached_file(:video) }
  end

  describe "accessibe attributes" do
	it { should_not allow_mass_assignment_of(:workout_id) }
  end  
end
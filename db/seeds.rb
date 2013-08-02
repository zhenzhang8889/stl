
# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)



u = User.create(:email => "a@b.com", :username => "awesome", :name => "foo bar", :password => "awesome")
k = u.workouts.build(:name => "awesome", :description => "blah blah")
k.save!


20.times do
  Status.find(511).notifications.create(email: u.email, notify_method: :site, notified: false, user_id: u.id, viewed: false, behaviour: "share")
end

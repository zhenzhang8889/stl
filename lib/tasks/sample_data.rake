namespace :db do
  desc "Fill database with sample data"
  task populate: :environment do
    require 'faker'

    #Rake::Task['db:reset'].invoke
    make_users
    make_statuses
    make_relationships
  end
end

def make_users
  admin = User.create!(name:     "Kris Jin",
                       username: "kris_jin81",
                       email:    "kris_jin81@gmail.com",
                       password: "kris_jin81")

 # admin.toggle!(:admin)
  99.times do |n|
    name  = Faker::Name.name
    username = "example-#{n+1}"
    email = "example-#{n+1}@railstutorial.org"
    password  = "password"
    User.create!(name:     name,
                 username: username,
                 email:    email,
                 password: password,
                 )
  end
end

def make_statuses
  users = User.all(limit: 6)

  50.times do
    name = Faker::Lorem.sentence(5)
    description = Faker::Lorem.paragraph(sentence_count = 3)
    users.each { |user| user.workouts.create!(name: name, description: description) }
  end
  50.times do
    name = Faker::Lorem.sentence(5)
    body = Faker::Lorem.paragraph(sentence_count = 3)
    users.each { |user| user.posts.create!(name: name, body: body) }
  end

end

def make_relationships
  users = User.all
  user  = users.first
  followed_users = users[2..50]
  followers      = users[3..40]
  followed_users.each { |followed| user.follow!(followed) }
  followers.each      { |follower| follower.follow!(user) }
end


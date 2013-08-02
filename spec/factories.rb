FactoryGirl.define do
  factory :feed do
    user
  end
  
  factory :user do
    name     { Faker::Name.name }
    email    { Faker::Internet.email }
    password "foobar"
    password_confirmation "foobar"
    username { Faker::Name.name }
  end

  factory :authentication do
    provider "social"
    uid "234234"
    token "akjasdfasd"
    token_secret "231451234123asdfasd"
  end

  factory :social_user, class: User do
    name     "Mr. Foo Bar"
    email    "foo@bar.com"
    password "foobar"
    password_confirmation "foobar"
    username "foobars"
  end

  factory :relationship do
    follower_id { FactoryGirl.create(:user).id }
    followed_id { FactoryGirl.create(:user).id }
  end

  factory :compliment do
    users
    motivator_id FactoryGirl.create(:user).id
    custom_message { Faker::Lorem.sentences 1 }

    factory :invalid_compliment do
      custom_message nil
    end

    factory :with_canned do
      custom_message nil
      canned_message { Faker::Lorem.sentences 1 }
    end

    factory :with_both do
      canned_message { Faker::Lorem.sentences 1 }
    end

    factory :with_long_message do
      custom_message "f" * 500
    end
  end

  factory :email_notification, class: Notification do
    user
    email { Faker::Internet.email }
    notify_method :email
    notified true
    behaviour :like_content
   end
   
   factory :post do 
     user
     name       { Faker::Lorem.characters(10) }
     body       { Faker::Lorem.characters(255) }
     
   end
   
   factory :workout do 
      user
      name              { Faker::Lorem.characters(10) }
      description       { Faker::Lorem.characters(255) }
    end
   
   factory :status do 
     user
     content { Faker::Lorem.characters(255) }
    end 
     
   factory :comment do 
      content { Faker::Lorem.characters(255)  }
    end 

    factory :exercise do
      workout
      name { Faker::Name.name }
      reps 23
      weight 45.5
      equipment { Faker::Lorem.sentences 2 }
      description { Faker::Lorem.sentences 10 }
    end
     
    factory :like do 
     user_id FactoryGirl.create(:user).id
    end 
   
   
 end
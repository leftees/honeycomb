FactoryGirl.define do
  factory :user do |u|
    u.id { 1 }
    u.first_name { "One" }
    u.last_name { "User" }
    u.display_name { "User One" }
    u.email { "noone@nowhere.com" }
    u.sign_in_count { 1 }
    u.username { "user1" }
    u.admin { true }
  end
end

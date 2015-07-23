FactoryGirl.define do
  factory :collection_user do |u|
    u.id { 1 }
    u.user_id { 1 }
    u.collection_id { 1 }
  end
end

FactoryGirl.define do
  factory :page do |s|
    s.id { 1 }
    s.name { "Page1" }
    s.content { "<p>One</p>" }
    s.collection_id { 1 }
    s.image_id { 1 }
  end
end

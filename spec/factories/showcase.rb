FactoryGirl.define do
  factory :showcase do |s|
    s.id  { 1 }
    s.exhibit_id { 1 }
    s.title { "Showcase One" }
    s.image { File.new(Rails.root + "spec/fixtures/1.bmp") }
  end
end

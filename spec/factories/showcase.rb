FactoryGirl.define do
  factory :showcase do |s|
    s.id  { 1 }
    s.exhibit_id { 1 }
    s.title { "Showcase One" }
    s.image_file_name 'one.jpg'
    s.image_content_type 'image/jpeg'
    s.image_file_size 1.megabyte

    factory :showcase_with_exhibit do
      after(:build, :create) do |s|
        s.exhibit = build(:exhibit_with_collection)
      end
    end
  end
end

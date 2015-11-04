FactoryGirl.define do
  factory :showcase do
    id { 1 }
    collection_id { 1 }
    name_line_1 { "Showcase One" }
    unique_id { "one" }
    image_file_name "one.jpg"
    image_content_type "image/jpeg"
    image_file_size 1.megabyte

    factory :showcase_with_collection do
      after(:build, :create) do |s|
        s.collection = build(:collection)
      end
    end
  end
end

FactoryGirl.define do
  factory :item do |i|
    i.id { 1 }
    i.name { "one" }
    i.collection_id { 1 }
    i.user_defined_id { "one" }
    image_file_name "one.jpg"
    image_content_type "image/jpeg"
    image_file_size 1.megabyte
  end
end

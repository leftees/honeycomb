FactoryGirl.define do
  factory :image do
    id { 1 }
    collection_id { 1 }
    image_file_name "one.jpg"
    image_content_type "image/jpeg"
    image_file_size 1.megabyte
    image_fingerprint "one"
  end
end

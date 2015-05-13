FactoryGirl.define do
  factory :exhibit do |s|
    s.id  { 1 }
    s.collection_id { 1 }
    #s.image { File.new(Rails.root + "spec/fixtures/1.bmp") }
  end
end

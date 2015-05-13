FactoryGirl.define do
  factory :exhibit do |e|
    e.id  { 1 }
    e.collection_id { 1 }

    factory :exhibit_with_collection do
      after(:build, :create) do |e|
        e.collection { build(:collection) }
      end
    end
  end
end

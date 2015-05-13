FactoryGirl.define do
  factory :exhibit do
    id  { 1 }
    collection_id { 1 }

    factory :exhibit_with_collection do
      after(:build, :create) do |e|
        e.collection { build(:collection) }
      end
    end
  end
end

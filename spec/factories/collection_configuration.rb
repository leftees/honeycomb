FactoryGirl.define do
  factory :collection_configuration do |cc|
    cc.id { 1 }
    cc.collection_id { 1 }
    cc.metadata { "{}" }
  end
end

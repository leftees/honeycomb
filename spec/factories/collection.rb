FactoryGirl.define do
  factory :collection do |s|
    s.id { 1 }
    s.name_line_1 { "Collection One" }
    s.unique_id { "one" }
  end
end

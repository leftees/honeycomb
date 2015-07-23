FactoryGirl.define do
  factory :section do |s|
    s.id { 1 }
    s.showcase_id { 1 }

    factory :section_with_showcase do
      after(:build, :create) do |ss|
        ss.showcase = build(:showcase_with_exhibit)
      end
    end
  end
end

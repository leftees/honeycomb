require "rails_helper"

RSpec.describe CollectionConfiguration do
  subject { CollectionConfiguration.new }
  [
    :collection,
    :metadata,
    :facets,
    :sorts
  ].each do |field|
    it "has field, #{field}" do
      expect(subject).to respond_to(field)
      expect(subject).to respond_to("#{field}=")
    end
  end
end

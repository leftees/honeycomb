require "rails_helper"

RSpec.describe Metadata::UpdateConfigurationField do
  let(:configuration) { double(Metadata::Configuration) }
  let(:collection) { double(Collection) }

  before(:each) do
    allow_any_instance_of(CollectionConfigurationQuery).to receive(:find).and_return(configuration)
  end

  it "calls save_field on the configuration" do
    expect(configuration).to receive(:save_field).with(:field_name, :new_data)
    described_class.call(collection, :field_name, :new_data)
  end
end

require "rails_helper"

RSpec.describe Metadata::CreateConfigurationField do
  let(:configuration) { double(Metadata::Configuration) }
  let(:collection) { double(Collection) }
  let(:data) { { name: "name" } }

  before(:each) do
    allow_any_instance_of(CollectionConfigurationQuery).to receive(:find).and_return(configuration)
    allow(configuration).to receive(:save_field)
    allow(Metadata::ConfigurationInputCleaner).to receive(:call).and_return(data)
  end

  it "calls save_field on the configuration" do
    expect(configuration).to receive(:save_field).with("name", data)
    described_class.call(collection, data)
  end

  it "calls the cleaner on the input data" do
    expect(Metadata::ConfigurationInputCleaner).to receive(:call).with(data)
    described_class.call(collection, data)
  end
end

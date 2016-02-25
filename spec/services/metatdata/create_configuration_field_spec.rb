require "rails_helper"

RSpec.describe Metadata::CreateConfigurationField do
  let(:configuration) { double(Metadata::Configuration) }
  let(:collection) { double(Collection) }
  let(:data) { { name: "name" } }

  before(:each) do
    allow_any_instance_of(CollectionConfigurationQuery).to receive(:find).and_return(configuration)
    allow(configuration).to receive(:save_field)
    allow(Metadata::ConfigurationInputCleaner).to receive(:call).and_return(data)
    allow_any_instance_of(CollectionConfigurationQuery).to receive(:max_metadata_order).and_return(0)
  end

  it "calls save_field on the configuration" do
    expect(configuration).to receive(:save_field).with("name", data)
    described_class.call(collection, data)
  end

  it "calls the cleaner on the input data" do
    expect(Metadata::ConfigurationInputCleaner).to receive(:call).with(data)
    described_class.call(collection, data)
  end

  it "uses CollectionConfigurationQuery to get a default order when one is not present" do
    data.delete(:order)
    expect_any_instance_of(CollectionConfigurationQuery).to receive(:max_metadata_order).and_return(0)
    described_class.call(collection, data)
  end

  it "doesn't call CollectionConfigurationQuery to get the max order when one is given" do
    data[:order] = 10
    expect_any_instance_of(CollectionConfigurationQuery).not_to receive(:max_metadata_order)
    described_class.call(collection, data)
  end

  it "uses the order given when one is present" do
    data[:order] = 10
    described_class.call(collection, data)
    expect(data[:order]).to eq(10)
  end

  it "populates a default value for active when one is not present" do
    data.delete(:active)
    described_class.call(collection, data)
    expect(data[:active]).to eq(true)
  end

  it "uses the value given for active when one is present" do
    data[:active] = false
    described_class.call(collection, data)
    expect(data[:active]).to eq(false)
  end
end

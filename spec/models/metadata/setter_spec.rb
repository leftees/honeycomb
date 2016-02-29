require "rails_helper"

RSpec.describe Metadata::Setter do
  let(:item) { instance_double(Item, metadata: metadata, collection: double) }
  let(:configuration) { instance_double(Metadata::Configuration, field?: true) }
  let(:new_metadata) { {} }
  let(:metadata) { {} }
  subject { described_class.call(item, metadata) }

  before(:each) do
    allow(MetadataInputCleaner).to receive(:call)
    allow_any_instance_of(CollectionConfigurationQuery).to receive(:find).and_return(configuration)
  end

  describe "call" do
    it "sets the field in the metadata" do
      metadata["field"] = "value"
      expect(metadata).to receive(:[]=).with("field", "value")
      subject
    end

    it "does not set the metadata if the field does not exist" do
      allow(configuration).to receive(:field?).and_return(false)
      expect(metadata).to_not receive(:[]=).with("field", "value")
      subject
    end

    it "calls the metadata cleaner after setting" do
      expect(MetadataInputCleaner).to receive(:call)
      subject
    end
  end
end

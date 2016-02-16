require "rails_helper"
require "cache_spec_helper"

RSpec.describe V1::ConfigurationsController, type: :controller do
  let(:collection) { instance_double(Collection, id: 1) }
  let(:collection_configuration) { double(Metadata::Configuration) }

  describe "show" do
    subject { get :show, collection_id: collection.id, format: :json }

    before(:each) do
      allow_any_instance_of(CollectionQuery).to receive(:any_find).and_return(collection)
      allow_any_instance_of(CollectionConfigurationQuery).to receive(:find).and_return(collection_configuration)
      allow_any_instance_of(V1::MetadataConfigurationJSON).to receive(:to_json).and_return("JSON")
    end

    it "calls to json on the V1::MetadataConfigurationJSON" do
      expect_any_instance_of(V1::MetadataConfigurationJSON).to receive(:to_json)
      subject
    end

    it "queries for the collection" do
      expect_any_instance_of(CollectionQuery).to receive(:any_find).and_return(collection)
      subject
    end

    it "queries for the configuration" do
      expect_any_instance_of(CollectionConfigurationQuery).to receive(:find).and_return(collection_configuration)
      subject
    end
  end
end

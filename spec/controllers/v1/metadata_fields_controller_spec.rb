require "rails_helper"
require "cache_spec_helper"

RSpec.describe V1::MetadataFieldsController, type: :controller do
  let(:collection) { instance_double(Collection, id: 1) }
  let(:update_params) { { label: "label" } }

  before(:each) do
    allow_any_instance_of(CollectionQuery).to receive(:any_find).and_return(collection)
  end

  describe "update" do
    let(:params) { { name: "name" } }
    subject { put :update, collection_id: 1, id: "id", fields: update_params }

    it "queries for the collection" do
      expect_any_instance_of(CollectionQuery).to receive(:any_find).and_return(collection)
      subject
    end

    it "uses the Metadata::UpdateConfigurationField to update the data" do
      expect(Metadata::UpdateConfigurationField).to receive(:call).with(collection, "id", update_params)
      subject
    end

    it "checks the editor permissions" do
      expect_any_instance_of(described_class).to receive(:user_can_edit?).with(collection)
      subject
    end
  end
end

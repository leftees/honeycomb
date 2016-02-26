require "rails_helper"
require "cache_spec_helper"

RSpec.describe V1::MetadataFieldsController, type: :controller do
  let(:collection) { instance_double(Collection, id: 1) }
  let(:configuration) { double(Metadata::Configuration) }

  before(:each) do
    allow_any_instance_of(CollectionQuery).to receive(:any_find).and_return(collection)
    @user = sign_in_admin
  end

  describe "update" do
    let(:params) { { label: "name" } }
    subject { put :update, collection_id: 1, id: "id", fields: params, format: :json }

    before(:each) do
      allow(Metadata::UpdateConfigurationField).to receive(:call).and_return(true)
    end

    it "queries for the collection" do
      expect_any_instance_of(CollectionQuery).to receive(:any_find).and_return(collection)
      subject
    end

    it "uses the Metadata::UpdateConfigurationField to update the data" do
      expect(Metadata::UpdateConfigurationField).to receive(:call).with(collection, "id", params)
      subject
    end

    it "checks the editor permissions" do
      expect_any_instance_of(described_class).to receive(:user_can_edit?).with(collection)
      subject
    end
  end

  describe "create" do
    let(:params) { { label: "name" } }
    subject { post :create, collection_id: 1, fields: params, format: :json }

    before(:each) do
      allow(Metadata::CreateConfigurationField).to receive(:call).and_return(true)
    end

    it "queries for the collection" do
      expect_any_instance_of(CollectionQuery).to receive(:any_find).and_return(collection)
      subject
    end

    it "uses the Metadata::CreateConfigurationField to update the data" do
      expect(Metadata::CreateConfigurationField).to receive(:call).with(collection, params)
      subject
    end

    it "checks the editor permissions" do
      expect_any_instance_of(described_class).to receive(:user_can_edit?).with(collection)
      subject
    end

    it "renders the status in the json response if the save succeeds" do
      subject
      expect(JSON.parse(response.body)).to include("status" => "success")
    end

    it "renders the new field in the json response if the save succeeds" do
      subject
      expect(JSON.parse(response.body)).to include("field" => true)
    end

    it "returns the status in the json response if the save fails" do
      allow(Metadata::CreateConfigurationField).to receive(:call).with(collection, params).and_return(false)
      subject
      expect(JSON.parse(response.body)).to include("status" => "unprocessable_entity")
    end

    it "returns the field params in the json response if the save fails" do
      allow(Metadata::CreateConfigurationField).to receive(:call).with(collection, params).and_return(false)
      subject
      expect(JSON.parse(response.body)).to include("field" => params.stringify_keys)
    end
  end
end

require "rails_helper"

RSpec.describe CreateCollectionConfiguration do
  subject { described_class.call(collection) }

  context "exhisting configuration" do
    let(:collection) { double(collection_configuration: "CONFIGURATION") }

    it "returns the current configuration if there is a configuration" do
      expect(subject).to eq("CONFIGURATION")
    end
  end

  context "no existing configuration" do
    let(:collection) { double(collection_configuration: nil, create_collection_configuration: double()) }

    it "builds a new configuration if there is not one" do
      expect(collection).to receive(:create_collection_configuration).and_return("CONFIGURATION")
      subject
    end

    it "returns the newly generted configuration" do
      allow(collection).to receive(:create_collection_configuration).and_return("CONFIGURATION")
      expect(subject).to eq("CONFIGURATION")
    end

    it "loads configuration from a yml file when there is no configuration" do
      expect(YAML).to receive(:load_file).with(Rails.root.join("config/metadata/", "item.yml")).and_return(fields: [])
      subject
    end

    it "passes the metadata, facets, and sorts from the config file to the create command" do
      allow(YAML).to receive(:load_file).with(Rails.root.join("config/metadata/", "item.yml")).and_return(fields: "fields", facets: "facets", sorts: "sorts")
      expect(collection).to receive(:create_collection_configuration).with(metadata: "fields", sorts: "sorts", facets: "facets")
      subject
    end
  end
end

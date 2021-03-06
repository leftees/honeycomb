require "rails_helper"

RSpec.describe Metadata::Fields do
  let(:item) { instance_double(Item, metadata: metadata) }
  let(:metadata) { { "name" => ["name"] } }
  let(:collection_configuration) { double(Metadata::Configuration, field: metadata_config, field_names: ["name"]) }
  let(:metadata_config) { double(name: "Name", label: "Label", type: :string) }

  let(:instance) { described_class.new(item) }

  before(:each) do
    allow_any_instance_of(described_class).to receive(:configuration).and_return(collection_configuration)
  end

  describe "fields" do
    it "returns all the fields as an array" do
      expect(instance.fields).to be_a(Hash)
    end

    it "calls field for each of the keys in the metadata" do
      expect(instance).to receive(:field).with("name").and_return(["name"])
      instance.fields
    end
  end

  describe "name" do
    it "tests if there is a name field" do
      expect(instance).to receive(:field?).with(:name).and_return(true)
      allow(instance).to receive(:field).with(:name).and_return([double(value: "name")])
      instance.name
    end

    it "returns nil if the field is not a field?" do
      allow(instance).to receive(:field?).with(:name).and_return(false)
      allow(instance).to receive(:field).with(:name).and_return([double(value: "name")])
      expect(instance.name).to be_nil
    end

    it "tests if there is a name value" do
      allow(instance).to receive(:field?).with(:name).and_return(true)
      expect(instance).to receive(:field).with(:name).and_return([double(value: "name")]).twice
      instance.name
    end

    it "returns nil if the field has no data" do
      allow(instance).to receive(:field?).with(:name).and_return(true)
      allow(instance).to receive(:field).with(:name).and_return(nil)
      expect(instance.name).to be_nil
    end

    it "returns the name" do
      allow(instance).to receive(:field?).with(:name).and_return(true)
      allow(instance).to receive(:field).with(:name).and_return([double(value: "name")])
      expect(instance.name).to eq("name")
    end
  end

  describe "description" do
    it "tests if there is a description field" do
      expect(instance).to receive(:field?).with(:description).and_return(true)
      allow(instance).to receive(:field).with(:description).and_return([double(value: "description")])
      instance.description
    end

    it "returns nil if the field is not a field?" do
      allow(instance).to receive(:field?).with(:description).and_return(false)
      allow(instance).to receive(:field).with(:description).and_return([double(value: "description")])
      expect(instance.description).to be_nil
    end

    it "tests if there is a description value" do
      allow(instance).to receive(:field?).with(:description).and_return(true)
      expect(instance).to receive(:field).with(:description).and_return([double(value: "description")]).twice
      instance.description
    end

    it "returns nil if the field has no data" do
      allow(instance).to receive(:field?).with(:description).and_return(true)
      allow(instance).to receive(:field).with(:description).and_return(nil)
      expect(instance.description).to be_nil
    end

    it "returns the description" do
      allow(instance).to receive(:field?).with(:description).and_return(true)
      allow(instance).to receive(:field).with(:description).and_return([double(value: "description")])
      expect(instance.description).to eq("description")
    end
  end

  describe "field" do
    it "returns the field value if the metadata exists and the key is a symbol" do
      expect(instance.field(:name)).to be_a(Array)
    end

    it "returns the field value if the metadata exists and the key is a string" do
      expect(instance.field("name")).to be_a(Array)
    end

    it "returns nil if there is no metadata" do
      expect(instance.field(:notakey)).to be(nil)
    end

    it "returns nil if there is no type in config" do
      allow(collection_configuration).to receive(:field).and_return(nil)
      expect(instance.field("name")).to be(nil)
    end

    it "returns a metadata string class whene there it is a string" do
      expect(instance).to receive(:string_value).and_return("string")
      expect(instance.field("name")).to eq("string")
    end

    it "returns a metadata date class whene there it is a date" do
      allow(metadata_config).to receive(:type).and_return(:date)
      expect(instance).to receive(:date_value).and_return("date")
      expect(instance.field("name")).to eq("date")
    end

    it "returns a metadata html class whene there it is a html" do
      allow(metadata_config).to receive(:type).and_return(:html)
      expect(instance).to receive(:html_value).and_return("html")
      expect(instance.field("name")).to eq("html")
    end

    it "errors on an unexpected field type" do
      allow(metadata_config).to receive(:type).and_return(:notatype)
      expect { instance.field("name") }.to raise_error("missing type")
    end

    it "ensures that the value is an array" do
      metadata["name"] = "name"
      expect(instance.field("name")).to be_a(Array)
    end
  end

  describe "field?" do
    it "returns true if the metadata has a symbol key" do
      expect(instance.field?(:name)).to be(true)
    end

    it "returns true of the metadata has as string key " do
      expect(instance.field?("name")).to be(true)
    end

    it "returns false if the metadata has a key" do
      expect(instance.field?(:notakey)).to be(false)
    end
  end

  describe "valid?" do
    it "uses the MetadataValidator" do
      expect_any_instance_of(MetadataValidator).to receive(:validate).with(instance)
      instance.valid?
    end
  end
end

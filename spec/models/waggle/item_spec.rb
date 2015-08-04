require "rails_helper"

RSpec.describe Waggle::Item do
  let(:item_id) { "pig-in-mud" }
  let(:raw_data) { File.read(Rails.root.join("spec/fixtures/v1/items/#{item_id}.json")) }
  let(:data) { JSON.parse(raw_data).fetch("items") }
  let(:instance) { described_class.new(data) }
  let(:other_instance) do
    data = instance.data.clone
    data["id"] += "other"
    data["metadata"]["name"]["value"] += " pig"
    described_class.new(data)
  end

  subject { instance }

  describe "id" do
    it "is the id" do
      expect(subject.id).to eq(data.fetch("id"))
    end
  end

  describe "name" do
    it "is the name in an array" do
      expect(subject.name).to eq([data.fetch("name")])
    end
  end

  describe "thumbnail_url" do
    it "is the correct value" do
      expect(subject.thumbnail_url).to be_present
      expect(subject.thumbnail_url).to eq(data["image"]["thumbnail/small"]["contentUrl"])
    end
  end

  describe "last_updated" do
    it "is a Time" do
      expect(subject.last_updated).to eq(Time.parse(data.fetch("last_updated")))
    end
  end

  describe "self.load" do
    it "loads from the file for now" do
      loaded = described_class.load(item_id)
      expect(loaded.data).to eq(data)
    end

    it "loads the correct way"
  end

  describe "metadata" do
    it "is a Metadata object" do
      expect(Waggle::Metadata::Set).to receive(:new).
        with(data.fetch("metadata"), Metadata::Configuration.item_configuration).and_call_original
      expect(subject.metadata).to be_kind_of(Waggle::Metadata::Set)
    end
  end

  describe "method_missing" do
    it "returns the metadata value for a metadata field" do
      expect(subject.metadata).to receive(:field?).with(:creator).and_return(true)
      expect(subject.metadata).to receive(:value).with(:creator).and_return("creator")
      expect(subject.creator).to eq("creator")
    end

    it "raises an error for any other missing methods" do
      expect(subject.metadata).to receive(:field?).with(:creator).and_return(false)
      expect { subject.creator }.to raise_error(NoMethodError)
    end
  end

  describe "respond_to?" do
    it "is true for a metadata field" do
      expect(subject.metadata).to receive(:field?).with(:creator).and_return(true)
      expect(subject.respond_to?(:creator)).to eq(true)
    end

    it "raises an error for any other missing methods" do
      expect(subject.metadata).to receive(:field?).with(:creator).and_return(false)
      expect(subject.respond_to?(:creator)).to eq(false)
    end
  end
end

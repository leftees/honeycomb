require "rails_helper"

RSpec.describe V1::MetadataJSON do
  subject { described_class.new(item) }

  let(:item) { Item.new }

  describe "#metadata" do
    it "calls the MetadataString class for string metadata" do
      allow(item).to receive(:name).and_return("name")
      expect_any_instance_of(MetadataString).to receive(:to_hash).and_return("hash")
      expect(subject.metadata).to eq(name: ["hash"])
    end

    it "calls the MetadataHtml class for html metadata" do
      allow(item).to receive(:description).and_return("desc")
      expect_any_instance_of(MetadataHtml).to receive(:to_hash).and_return("hash")
      expect(subject.metadata).to eq(description: ["hash"])
    end

    it "calls the MetadataDate class for date metadata" do
      allow(item).to receive(:date_modified).and_return(year: "2010")
      expect_any_instance_of(MetadataDate).to receive(:to_hash).and_return("hash")
      expect(subject.metadata).to eq(date_modified: ["hash"])
    end
  end
end

require "rails_helper"

RSpec.describe Waggle::Metadata::Value do
  let(:data) { { "@type" => "MetadataString", "value" => "Bob Smith" } }

  describe "from_hash" do
    subject { described_class.from_hash(data) }

    it "returns a String instance" do
      data["@type"] = "MetadataString"
      expect(subject).to be_kind_of(described_class::String)
    end

    it "returns a Date instance" do
      data["@type"] = "MetadataDate"
      expect(subject).to be_kind_of(described_class::Date)
    end

    it "returns an HTML instance" do
      data["@type"] = "MetadataHTML"
      expect(subject).to be_kind_of(described_class::HTML)
    end
  end
end

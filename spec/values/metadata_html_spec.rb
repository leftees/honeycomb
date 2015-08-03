require "rails_helper"

RSpec.describe MetadataHTML do
  describe "#to_hash" do
    it "generates a hash from the data" do
      expect(described_class.new("value").to_hash()).to eq("@type" => "MetadataHTML", value: "value")
    end
  end

  describe "#value" do
    it "is the value passed in" do
      expect(described_class.new("value").value).to eq("value")
    end
  end
end

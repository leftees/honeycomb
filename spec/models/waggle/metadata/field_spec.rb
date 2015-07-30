require "rails_helper"

RSpec.describe Waggle::Metadata::Field do
  let(:data) do
    {
      "@type" => "MetadataField",
      "name" => "creator",
      "label" => "Creator",
      "values" => [
        {
          "@type" => "MetadataString",
          "value" => "Bob Smith"
        },
        {
          "@type" => "MetadataString",
          "value" => "John Doe"
        }
      ]
    }
  end

  subject { described_class.new(data) }

  describe "type" do
    it "is MetadataField" do
      expect(subject.type).to eq("MetadataField")
    end
  end

  describe "name" do
    it "is the field name" do
      expect(subject.name).to eq("creator")
    end
  end

  describe "label" do
    it "is the field label" do
      expect(subject.label).to eq("Creator")
    end
  end

  describe "values" do
    it "is an array of values" do
      expect(subject.values).to be_kind_of(Array)
      expect(subject.values.first).to be_kind_of(Waggle::Metadata::Value::Base)
    end
  end
end

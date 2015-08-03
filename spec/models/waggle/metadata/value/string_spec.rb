require "rails_helper"

RSpec.describe Waggle::Metadata::Value::String do
  let(:data) { { "@type" => "MetadataString", "value" => "Bob Smith" } }

  subject { described_class.new(data) }

  describe "value" do
    it "is a string value" do
      expect(subject.value).to eq("Bob Smith")
    end

    it "converts to a string" do
      data["value"] = 123
      expect(subject.value).to eq("123")
    end
  end
end

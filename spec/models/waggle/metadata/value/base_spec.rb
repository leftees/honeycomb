require "rails_helper"

RSpec.describe Waggle::Metadata::Value::Base do
  let(:data) { { "@type" => "MetadataString", "value" => "Bob Smith" } }

  subject { described_class.new(data) }

  describe "data" do
    it "is stored" do
      expect(subject.send(:data)).to eq(data)
    end
  end

  describe "type" do
    it "is the type" do
      expect(subject.type).to eq("MetadataString")
    end
  end

  describe "value" do
    it "raises an error that it's not implemented" do
      expect { subject.value }.to raise_error("not implemented")
    end
  end

  describe "raw_value" do
    it "is the original value" do
      expect(subject.raw_value).to eq(data.fetch("value"))
    end
  end
end

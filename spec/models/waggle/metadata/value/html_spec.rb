require "rails_helper"

RSpec.describe Waggle::Metadata::Value::HTML do
  let(:data) { { "@type" => "MetadataHTML", "value" => "<p>Lorem ipsum</p>" } }

  subject { described_class.new(data) }

  describe "value" do
    it "strips html tags" do
      data["value"] = "<p>Lorem ipsum</p>"
      expect(subject.value).to eq("Lorem ipsum")
    end

    it "does not alter strings without tags" do
      data["value"] = "No tags"
      expect(subject.value).to eq("No tags")
    end
  end
end

require "rails_helper"

RSpec.describe Waggle::Metadata::Value::Date do
  let(:data) do
    {
      "@type" => "MetadataDate",
      "value" => "March 2013",
      "iso8601" => "2013-03-24",
      "year" => "2013",
      "month" => "03",
      "day" => "24",
      "bc" => "false",
      "displayText" => "March 2013"
    }
  end
  let(:date_format) { "%Y-%m-%dT%H:%M:%SZ" }

  subject { described_class.new(data) }

  describe "value" do
    it "is a datetime" do
      expect(subject.value).to eq("2013-03-24")
    end

    it "can be in bc" do
      data["iso8601"] = "-2010-10-15"
      expect(subject.value).to eq("-2010-10-15")
    end
  end
end

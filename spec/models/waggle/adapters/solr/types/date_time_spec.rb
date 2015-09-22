RSpec.describe Waggle::Adapters::Solr::Types::DateTime do
  subject { described_class }
  describe "field_name" do
    it "returns the field name with suffix" do
      expect(subject.field_name(:name)).to eq(:name_dt)
    end
  end

  describe "value" do
    it "converts a date to a string" do
      expect(subject.value(Date.new(2015, 9, 25))).to eq("2015-09-25T00:00:00Z")
    end

    it "converts a datetime to a string" do
      expect(subject.value(DateTime.new(2015, 9, 25, 16, 30))).to eq("2015-09-25T16:30:00Z")
    end

    it "converts a date string to the correct format" do
      expect(subject.value("2015-09-25")).to eq("2015-09-25T00:00:00Z")
    end

    it "uses the first value if multivalued" do
      expect(subject.value([Date.new(2015, 9, 25), Date.new(2015, 10, 25)])).to eq("2015-09-25T00:00:00Z")
    end

    it "raises an ArgumentError on an unexpected type" do
      expect { subject.value(Object) }.to raise_error(ArgumentError)
    end
  end
end

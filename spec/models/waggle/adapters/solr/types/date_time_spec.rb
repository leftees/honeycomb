RSpec.describe Waggle::Adapters::Solr::Types::DateTime do
  subject { described_class }
  describe "field_name" do
    it "returns the field name with suffix" do
      expect(subject.field_name(:name)).to eq(:name_dt)
    end
  end

  describe "as_solr" do
    it "converts a date to a string" do
      expect(subject.as_solr(Date.new(2015, 9, 25))).to eq("2015-09-25T00:00:00Z")
    end

    it "converts a datetime to a string" do
      expect(subject.as_solr(DateTime.new(2015, 9, 25, 16, 30))).to eq("2015-09-25T16:30:00Z")
    end

    it "converts a date string to the correct format" do
      expect(subject.as_solr("2015-09-25")).to eq("2015-09-25T00:00:00Z")
    end

    it "uses the first value if multivalued" do
      expect(subject.as_solr([Date.new(2015, 9, 25), Date.new(2015, 10, 25)])).to eq("2015-09-25T00:00:00Z")
    end

    it "raises an ArgumentError on an unexpected type" do
      expect { subject.as_solr(Object) }.to raise_error(ArgumentError)
    end
  end

  describe "from_solr" do
    it "converts a string to a date" do
      expect(subject.from_solr("2015-09-25T16:30:00Z")).to eq(DateTime.new(2015, 9, 25, 16, 30).utc)
    end
  end
end

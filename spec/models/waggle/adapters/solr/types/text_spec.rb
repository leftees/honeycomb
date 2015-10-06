RSpec.describe Waggle::Adapters::Solr::Types::Text do
  subject { described_class }
  describe "field_name" do
    it "returns the field name with suffix" do
      expect(subject.field_name(:name)).to eq(:name_t)
    end
  end

  describe "as_solr" do
    it "returns the value" do
      expect(subject.as_solr("Cat")).to eq("Cat")
    end

    it "can be multivalued" do
      expect(subject.as_solr(["Cat", "Dog"])).to eq(["Cat", "Dog"])
    end

    it "converts multiple values to strings" do
      expect(subject.as_solr([123, 456])).to eq(["123", "456"])
    end

    it "converts a value to a string" do
      expect(subject.as_solr(123)).to eq("123")
    end
  end

  describe "from_solr" do
    it "is the value" do
      expect(subject.from_solr("Rabbit")).to eq("Rabbit")
    end
  end
end

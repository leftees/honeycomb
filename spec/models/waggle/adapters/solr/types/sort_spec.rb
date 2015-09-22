RSpec.describe Waggle::Adapters::Solr::Types::Sort do
  subject { described_class }
  describe "field_name" do
    it "returns the field name with suffix" do
      expect(subject.field_name(:name)).to eq(:name_sort)
    end
  end

  describe "as_solr" do
    it "returns the value" do
      expect(subject.as_solr("Cat")).to eq("Cat")
    end

    it "converts an array to a single value" do
      expect(subject.as_solr(["Cat", "Dog"])).to eq("Cat Dog")
    end
  end

  describe "from_solr" do
    it "is the value" do
      expect(subject.from_solr("Rabbit")).to eq("Rabbit")
    end
  end
end

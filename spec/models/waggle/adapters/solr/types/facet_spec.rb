RSpec.describe Waggle::Adapters::Solr::Types::Facet do
  subject { described_class }
  describe "field_name" do
    it "returns the field name with suffix" do
      expect(subject.field_name(:name)).to eq(:name_facet)
    end
  end

  describe "value" do
    it "returns the value" do
      expect(subject.value("Cat")).to eq("Cat")
    end

    it "can be multivalued" do
      expect(subject.value(["Cat", "Dog"])).to eq(["Cat", "Dog"])
    end
  end
end

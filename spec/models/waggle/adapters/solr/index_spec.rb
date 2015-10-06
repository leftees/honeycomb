RSpec.describe Waggle::Adapters::Solr::Index do
  subject { described_class }
  describe "facet_field_name" do
    it "returns a field name" do
      expect(subject.facet_field_name(:name)).to eq(:name_facet)
    end
  end

  describe "sort_field_name" do
    it "returns a field name" do
      expect(subject.sort_field_name(:name)).to eq(:name_sort)
    end
  end

  describe "string_field_name" do
    it "returns a field name" do
      expect(subject.string_field_name(:name)).to eq(:name_s)
    end
  end

  describe "text_field_name" do
    it "returns a field name" do
      expect(subject.text_field_name(:name)).to eq(:name_t)
    end
  end

  describe "datetime_field_name" do
    it "returns a field name" do
      expect(subject.datetime_field_name(:name)).to eq(:name_dt)
    end
  end
end

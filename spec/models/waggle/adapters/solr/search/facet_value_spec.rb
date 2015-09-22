require "rails_helper"

RSpec.describe Waggle::Adapters::Solr::Search::FacetValue do
  let(:row) { ["Bob Bobbers", 10] }

  subject { described_class.new(row) }

  describe "value" do
    it "is the row value" do
      expect(subject.value).to eq(row[0])
    end
  end

  describe "name" do
    it "is the value" do
      expect(subject.name).to eq(subject.value)
    end
  end

  describe "count" do
    it "is the row count" do
      expect(subject.count).to eq(row[1])
    end
  end
end

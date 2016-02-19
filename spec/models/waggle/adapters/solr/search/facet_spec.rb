require "rails_helper"

RSpec.describe Waggle::Adapters::Solr::Search::Facet do
  let(:facet_fields) do
    { "creator_facet" => ["Bob Bobbers", 10, "Sven Svenly", 5, "Norbert", 1] }
  end
  let(:facet_rows) { facet_fields.fetch("creator_facet") }
  let(:facet_config) { instance_double(Metadata::Configuration::Facet, name: "creator", label: "Creator", active: false) }
  let(:instance) { described_class.new(facet_rows: facet_rows, facet_config: facet_config) }
  subject { instance }

  describe "field" do
    it "is the name of the facet config" do
      expect(subject.field).to eq(facet_config.name)
    end
  end

  describe "name" do
    it "is the label of the facet config" do
      expect(subject.name).to eq(facet_config.label)
    end
  end

  describe "active" do
    it "is the value of the facet config" do
      expect(subject.active).to eq(facet_config.active)
    end
  end

  describe "values" do
    it "instantiates a new facet value for each pair" do
      [
        ["Bob Bobbers", 10],
        ["Sven Svenly", 5],
        ["Norbert", 1],
      ].each do |row|
        expect(Waggle::Adapters::Solr::Search::FacetValue).to receive(:new).with(row).and_call_original
      end
      expect(subject.values.count).to eq(3)
    end
  end
end

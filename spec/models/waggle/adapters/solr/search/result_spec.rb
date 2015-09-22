require "rails_helper"

RSpec.describe Waggle::Adapters::Solr::Search::Result do
  let(:raw_response) { File.read(Rails.root.join("spec/fixtures/waggle/solr_response.json")) }
  let(:response) { JSON.parse(raw_response) }
  let(:query) do
    Waggle::Search::Query.new(
      q: "query",
      start: 60,
      rows: 20,
      filters: {},
    )
  end

  let(:instance) { described_class.new(query: query) }
  subject { instance }

  context "response" do
    before do
      allow(subject.send(:connection)).to receive(:paginate).and_return(response)
    end

    describe "total" do
      it "is the total number of results" do
        expect(subject.total).to eq(2)
      end
    end

    describe "hits" do
      it "returns an array of hits" do
        expect(subject.hits).to be_kind_of(Array)
        expect(subject.hits.first).to be_kind_of(Waggle::Adapters::Solr::Search::Hit)
      end
    end

    describe "facets" do
      it "returns an array of facets" do
        expect(subject.facets).to be_kind_of(Array)
        expect(subject.facets.first).to be_kind_of(Waggle::Adapters::Solr::Search::Facet)
      end
    end
  end

  describe "result" do
    it "sends the expected arguments to solr" do
      expect(subject).to receive(:page).and_return(2)
      expect(subject).to receive(:per_page).and_return(15)
      expect(subject).to receive(:solr_params).and_return(q: "a query")
      expect(subject.send(:connection)).to receive(:paginate).with(
        2,
        15,
        "select",
        params: {
          q: "a query"
        },
      ).and_return("solr_response")
      expect(subject.result).to eq("solr_response")
    end
  end

  describe "solr_params" do
    subject { instance.send(:solr_params) }

    it "returns the expected params" do
      expect(subject).to eq(
        q: "query",
        fl: "score *",
        fq: [],
        sort: "score asc",
        facet: true,
        :"facet.field" => [
          "{!ex=creator_facet}creator_facet",
          "{!ex=language_facet}language_facet"
        ]
      )
    end
  end
end

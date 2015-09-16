RSpec.describe Waggle::Search::Result do
  let(:adapter_result) { instance_double(Waggle::Adapters::Sunspot::Search::Result) }
  let(:query) { instance_double(Waggle::Search::Query) }
  let(:instance) { described_class.new(query: query) }

  subject { instance }

  before do
    allow(Waggle.adapter).to receive(:search_result).and_return(adapter_result)
  end

  describe "instance" do
    it "initializes with the query" do
      expect(subject.query).to eq(query)
    end
  end

  describe "start" do
    it "is the query start" do
      expect(query).to receive(:start).and_return(30)
      expect(subject.start).to eq(30)
    end
  end

  describe "rows" do
    it "is the query rows" do
      expect(query).to receive(:rows).and_return(15)
      expect(subject.rows).to eq(15)
    end
  end

  describe "total" do
    it "is the result total" do
      expect(adapter_result).to receive(:total).and_return(100)
      expect(subject.total).to eq(100)
    end
  end

  describe "hits" do
    let(:adapter_hits) { ["hit 1", "hit 2"] }
    it "maps the adapter hits to Waggle::Search::Hit instances" do
      expect(adapter_result).to receive(:hits).and_return(adapter_hits)
      adapter_hits.each do |hit|
        expect(Waggle::Search::Hit).to receive(:new).with(hit).and_call_original
      end
      expect(subject.hits).to match([kind_of(Waggle::Search::Hit), kind_of(Waggle::Search::Hit)])
    end
  end
end

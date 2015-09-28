RSpec.describe Waggle::Search::Query do
  let(:arguments) do
    {
      q: "query",
      facets: "facets",
      sort: "sort",
      rows: 20,
      start: 40,
      filters: { collection_id: "collection_id" }
    }
  end

  let(:instance) { described_class.new(**arguments) }

  subject { instance }

  it "initializes and sets arguments" do
    arguments.each do |key, value|
      expect(subject.send(key)).to eq(value)
    end
  end

  describe "result" do
    subject { instance.result }
    it "returns a Waggle::Search::Result" do
      expect(Waggle::Search::Result).to receive(:new).with(query: instance).and_call_original
      expect(subject).to be_kind_of(Waggle::Search::Result)
    end
  end
end

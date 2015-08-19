RSpec.describe Waggle::Adapters::Sunspot::Search::Result do
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

  before :all do
    unstub_solr
    Waggle::Adapters::Sunspot.send(:setup_indexers)
  end

  after :all do
    stub_solr
  end

  describe "query" do
    it "is the specified query" do
      expect(subject.query).to eq(query)
    end
  end

  describe "page" do
    it "is the page based on the query start and rows" do
      expect(query).to receive(:start).and_return(40)
      expect(query).to receive(:rows).and_return(20)
      expect(subject.page).to eq(3)
    end
  end

  describe "total" do
    it "is the search total" do
      expect(subject.send(:search)).to receive(:total).and_return(5)
      expect(subject.total).to eq(5)
    end
  end

  describe "hits" do
    let(:search_hits) { ["hit 1", "hit 2"] }
    it "maps the search hits" do
      expect(subject.send(:search)).to receive(:hits).and_return(search_hits)
      search_hits.each do |hit|
        expect(Waggle::Adapters::Sunspot::Search::Hit).to receive(:new).with(hit).and_call_original
      end
      expect(subject.hits).to match([kind_of(Waggle::Adapters::Sunspot::Search::Hit)] * search_hits.count)
    end
  end

  describe "search" do
    subject { instance.send(:search) }

    before do
      allow_any_instance_of(Sunspot::DSL::Search).to receive(:facet)
    end

    it "works" do
      expect(subject).to be_kind_of(Sunspot::Search::StandardSearch)
    end

    it "paginates" do
      expect_any_instance_of(Sunspot::DSL::Search).to receive(:paginate).with(page: 4, per_page: 20)
      subject
    end

    it "searches text" do
      expect_any_instance_of(Sunspot::DSL::Search).to receive(:fulltext).with("query")
      subject
    end

    it "filters" do
      query.filters[:collection_id] = "test_id"
      expect_any_instance_of(Sunspot::DSL::Search).to receive(:with).with(:collection_id, "test_id")
      subject
    end

    it "facets" do
      expect_any_instance_of(Sunspot::DSL::Search).to receive(:facet).with(:creator_facet, exclude: [])
      subject
    end

    it "filters on a facet and excludes the filter" do
      query.facets[:creator] = "bob"
      expect_any_instance_of(Sunspot::DSL::Search).to receive(:with).with(:creator_facet, "bob").and_return("creator filter")
      expect_any_instance_of(Sunspot::DSL::Search).to receive(:facet).with(:creator_facet, exclude: ["creator filter"])
      subject
    end
  end

  describe "searching" do
    let(:item_id) { "pig-in-mud" }
    let(:raw_data) { File.read(Rails.root.join("spec/fixtures/v1/items/#{item_id}.json")) }
    let(:data) { JSON.parse(raw_data).fetch("items") }
    let(:index_class) { Waggle::Item }
    let(:item_instance) { index_class.new(data) }
    let(:other_item_instance) do
      data = item_instance.data.clone
      data["id"] += "other"
      data["metadata"]["name"]["values"].first["value"] += " pig"
      index_class.new(data)
    end

    it "is searchable" do
      Sunspot.index(item_instance)
      Sunspot.index(other_item_instance)
      Sunspot.commit

      q = "pig"

      search = Sunspot.search index_class do
        fulltext q do
          boost_fields name: 3.0
          highlight :name
        end
      end

      # search.hits.each do |hit|
      #   stored_values = hit.instance_variable_get(:@stored_values)
      #   pp hit.stored(:name)
      #   pp stored_values
      # end

      hit = search.hits.detect { |h| h.primary_key == item_instance.id }
      expect(hit.highlights.first).to be_kind_of(Sunspot::Search::Highlight)
      expect(hit.highlights.first.formatted).to eq("<em>pig</em>-in-mud")
      expect(hit.stored(:name)).to eq(["pig-in-mud"])
    end
  end
end

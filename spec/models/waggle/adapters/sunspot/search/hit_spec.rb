RSpec.describe Waggle::Adapters::Sunspot::Search::Hit do
  let(:item_id) { "pig-in-mud" }
  let(:raw_data) { File.read(Rails.root.join("spec/fixtures/v1/items/#{item_id}.json")) }
  let(:data) { JSON.parse(raw_data).fetch("items") }
  let(:index_class) { Waggle::Item }
  let(:instance) { index_class.new(data) }
  let(:sunspot_hit) do
    Sunspot.index(instance)
    Sunspot.commit

    search = Sunspot.search index_class do
      with(:unique_id, instance.unique_id)
    end

    search.hits.first
  end
  let(:hit) { described_class.new(sunspot_hit) }

  subject { hit }

  before :all do
    unstub_solr
    Waggle::Adapters::Sunspot.setup_indexers
  end

  after :all do
    stub_solr
  end

  describe "name" do
    it "is the name" do
      expect(hit.name).to eq(instance.name.first)
    end
  end

  [:at_id, :unique_id, :collection_id, :type, :thumbnail_url, :last_updated].each do |field|
    it "returns #{field}" do
      expect(hit.send(field)).to eq(instance.send(field).to_s)
    end
  end

  describe "at_id" do
    it "is the @id" do
      expect(hit.at_id).to eq(data.fetch("@id"))
    end
  end

  describe "last_updated" do
    it "is a Time" do
      expect(hit.last_updated).to be_kind_of(Time)
    end
  end
end

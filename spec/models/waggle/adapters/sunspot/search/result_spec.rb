RSpec.describe Waggle::Adapters::Sunspot::Search::Result do
  let(:item_id) { "pig-in-mud" }
  let(:raw_data) { File.read(Rails.root.join("spec/fixtures/v1/items/#{item_id}.json")) }
  let(:data) { JSON.parse(raw_data).fetch("items") }
  let(:index_class) { Waggle::Item }
  let(:instance) { index_class.new(data) }
  let(:other_instance) do
    data = instance.data.clone
    data["id"] += "other"
    data["metadata"]["name"]["values"].first["value"] += " pig"
    index_class.new(data)
  end

  before :all do
    unstub_solr
    Waggle::Adapters::Sunspot.send(:setup_indexers)
  end

  after :all do
    stub_solr
  end

  it "is searchable" do
    Sunspot.index(instance)
    Sunspot.index(other_instance)
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

    hit = search.hits.detect { |h| h.primary_key == instance.id }
    expect(hit.highlights.first).to be_kind_of(Sunspot::Search::Highlight)
    expect(hit.highlights.first.formatted).to eq("<em>pig</em>-in-mud")
    expect(hit.stored(:name)).to eq(["pig-in-mud"])
  end
end

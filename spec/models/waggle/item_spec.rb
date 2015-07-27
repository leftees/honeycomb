require "rails_helper"

RSpec.describe Waggle::Item do
  let(:item_id) { "pig-in-mud" }
  let(:raw_data) { File.read(Rails.root.join("spec/fixtures/v1/items/#{item_id}.json")) }
  let(:data) { JSON.parse(raw_data).fetch("items") }
  let(:instance) { described_class.new(data) }
  let(:other_instance) do
    data = instance.data.clone
    data["id"] += "other"
    data["name"] += " pig"
    described_class.new(data)
  end

  subject { instance }

  before :all do
    unstub_solr
  end

  after :all do
    stub_solr
  end

  it "has a title" do
    expect(subject.name).to eq("pig-in-mud")
  end

  describe "self.load" do
    it "loads from the file for now" do
      loaded = described_class.load(item_id)
      expect(loaded.data).to eq(data)
    end

    it "loads the correct way"
  end

  it "is searchable" do
    Sunspot.setup(described_class) do
      text :name, stored: true
      string :name_facet
    end

    Sunspot.index(subject)
    Sunspot.index(other_instance)
    Sunspot.commit

    q = "pig"
    name_q = "pig-in-mud"

    search = Sunspot.search described_class do
      fulltext "pig" do
        boost_fields name: 3.0
        highlight :name
      end

      if name_q.present?
        name_filter = with(:name_facet, name_q)
        facet :name_facet, exclude: [name_filter]
      else
        facet :name_facet
      end
    end

    expect(search.facet(:name_facet).rows.first.value).to eq("pig-in-mud")
    # search.hits.each do |hit|
    #   stored_values = hit.instance_variable_get(:@stored_values)
    #   pp stored_values
    # end

    hit = search.hits.select { |h| h.primary_key == subject.id }.first

    expect(hit.highlights.first.formatted).to eq("<em>pig</em>-in-mud")
    expect(hit.stored(:name)).to eq(["pig-in-mud"])
  end
end

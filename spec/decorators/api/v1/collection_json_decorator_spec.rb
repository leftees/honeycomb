require 'rails_helper'

RSpec.describe API::V1::CollectionJSONDecorator do
  subject {described_class.new(collection)}

  let(:collection) { double(Collection, id: 1, unique_id: "adsf", title: 'title title', items: [] )}
  let(:json) { double }

  describe "#at_id" do

    it "returns the path to the id" do
      expect(subject.at_id).to eq("http://test.host/api/v1/collections/adsf")
    end

  end


  describe "#items_url" do

    it "returns the path to the items" do
      expect(subject.items_url).to eq("http://test.host/api/v1/collections/adsf/items")
    end

  end

  describe "#slug" do

    it "Calls the slug generator" do
      expect(CreateURLSlug).to receive(:call).with(collection.title).and_return('slug')
      expect(subject.slug).to eq("slug")
    end

  end


  describe "#items" do

    it "queries for all the published items" do
      expect_any_instance_of(ItemQuery).to receive(:published).and_return(["items"])
      expect(subject.items).to eq(['items'])
    end

  end

  describe "#display" do

    it "calls the partial for the display" do
      expect(json).to receive(:partial!).with("api/v1/collections/collection", {:collection_object => collection })
      subject.display(json)
    end

  end
end

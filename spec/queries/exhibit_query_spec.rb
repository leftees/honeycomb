require "rails_helper"

describe ExhibitQuery do
  subject { described_class.new(relation) }
  let(:relation) { Exhibit.all }

  describe "find" do
    it "finds the object" do
      expect(relation).to receive(:find).with(1)
      subject.find(1)
    end
  end

  describe "build" do
    it "builds a object off of the relation" do
      expect(relation).to receive(:build)
      subject.build
    end

    it "accepts default arguments" do
      exhibit = subject.build(collection_id: 1)
      expect(exhibit.collection_id).to eq(1)
    end
  end

  describe "for_collections" do
    let(:collections) { [1, 2] }

    it "returns all the exhibits for a collection" do
      expect(relation).to receive(:where).with(collection: collections[0])
      subject.for_collections(collections: collections[0])
    end

    it "returns all the exhibits for a list of collections" do
      expect(relation).to receive(:where).with(collection: collections)
      subject.for_collections(collections: collections)
    end
  end
end

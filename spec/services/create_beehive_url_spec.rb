require "rails_helper"

RSpec.describe CreateBeehiveURL do
  subject { described_class.call(object) }

  describe "#create" do
    context "Collection" do
      let(:object) { double(Collection, id: 1, unique_id: "12345678", title: "A Collection") }

      it "returns a beehive url for a collection" do
        expect(object).to receive(:is_a?).and_return(true)
        expect(subject).to receive(:create).and_return("http://localhost:3018/12345678/a-collection")
        subject.create
      end

      it "calls CreateURLSlug on the collection title" do
        expect(object).to receive(:is_a?).and_return(true)
        expect(CreateURLSlug).to receive(:call).with(object.title).and_return("a-collection")
        subject
      end
    end

    context "Item" do
      let(:collection) { double(Collection, unique_id: "12345678", title: "A Collection") }
      let(:object) { double(Item, unique_id: "87654321", name: "An Item", collection: collection, title: "An Item") }

      it "returns a beehive item url" do
        expect(object).to receive(:is_a?).and_return(false)
        expect(subject).to receive(:create).and_return("http://localhost:3018/12345678/a-collection/items/87654321/an-item")
        subject.create
      end

      it "calls CreateURLSlug on the collection and item names" do
        expect(object).to receive(:is_a?).and_return(false)
        expect(CreateURLSlug).to receive(:call).with(object.collection.title).and_return("a-collection")
        expect(CreateURLSlug).to receive(:call).with(object.name).and_return("an-item")
        subject
      end
    end
  end

  describe "#call" do
    let(:object) { double(Collection) }

    it "calls create" do
      expect_any_instance_of(CreateBeehiveURL).to receive(:create)
      described_class.call(object)
    end
  end
end

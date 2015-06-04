require "rails_helper"

RSpec.describe CacheKeys::Custom::V1Items do
  context "index" do
    let(:collection) { instance_double(Collection, items: "items") }

    it "uses CacheKeys::ActiveRecord" do
      expect_any_instance_of(CacheKeys::ActiveRecord).to receive(:generate)
      subject.index(collection: collection)
    end

    it "uses the correct data" do
      expect_any_instance_of(CacheKeys::ActiveRecord).to receive(:generate).with(record: [collection, "items"])
      subject.index(collection: collection)
    end
  end

  context "show" do
    let(:item) { instance_double(Item, collection: "collection", children: "children") }

    it "uses CacheKeys::ActiveRecord" do
      expect_any_instance_of(CacheKeys::ActiveRecord).to receive(:generate)
      subject.show(item: item)
    end

    it "uses the correct data" do
      expect_any_instance_of(CacheKeys::ActiveRecord).to receive(:generate).with(record: [item, "collection", "children"])
      subject.show(item: item)
    end
  end

  context "showcases" do
    let(:item) { instance_double(Item, collection: "collection", children: "children", showcases: "showcases") }

    it "uses CacheKeys::ActiveRecord" do
      expect_any_instance_of(CacheKeys::ActiveRecord).to receive(:generate)
      subject.showcases(item: item)
    end

    it "uses the correct data" do
      expect_any_instance_of(CacheKeys::ActiveRecord).to receive(:generate).with(record: [item, "collection", "showcases"])
      subject.showcases(item: item)
    end
  end
end

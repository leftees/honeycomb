require "rails_helper"
require "support/item_meta_helpers"

RSpec.configure do |c|
  c.include ItemMetaHelpers, helpers: :item_meta_helpers
end

RSpec.describe CreateItems, helpers: :item_meta_helpers do
  let(:items) do
    [
      item_meta_hash(item_id: 1),
      item_meta_hash(item_id: 2),
      item_meta_hash(item_id: 3),
    ]
  end
  let(:remapped_items) do
    [
      item_meta_hash_remapped(item_id: 1),
      item_meta_hash_remapped(item_id: 2),
      item_meta_hash_remapped(item_id: 3),
    ]
  end

  it "creates new item with the remapped properties" do
    allow(SaveItem).to receive(:call).and_return true
    rewrites = RewriteItemMetadata.new
    expect(Item).to receive(:new).with(hash_including(remapped_items[0])).ordered
    expect(Item).to receive(:new).with(hash_including(remapped_items[1])).ordered
    expect(Item).to receive(:new).with(hash_including(remapped_items[2])).ordered
    described_class.call(collection_id: 1, items_hash: items, rewrite_rules: [rewrites])
  end

  it "uses SaveItem service to save all items" do
    allow(Item).to receive(:new).and_return(nil)
    expect(SaveItem).to receive(:call).exactly(3).and_return true
    described_class.call(collection_id: 1, items_hash: items)
  end

  it "uses the given rewrite_rules on all items" do
    allow(Item).to receive(:new).and_return(nil)
    allow(SaveItem).to receive(:call).and_return true
    rewrites = RewriteItemMetadata.new
    expect(rewrites).to receive(:rewrite).with(item_hash: items[0]).ordered.and_return({})
    expect(rewrites).to receive(:rewrite).with(item_hash: items[1]).ordered.and_return({})
    expect(rewrites).to receive(:rewrite).with(item_hash: items[2]).ordered.and_return({})
    described_class.call(collection_id: 1, items_hash: items, rewrite_rules: [rewrites])
  end

  it "throws an exception if a label is not found" do
    items[0]["Invalid Field Name"] = "invalid value"
    rewrites = RewriteItemMetadata.new
    expect do
      described_class.call(collection_id: 1, items_hash: items, rewrite_rules: [rewrites])
    end.to raise_error(ActiveRecord::UnknownAttributeError)
  end
end

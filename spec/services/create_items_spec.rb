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
  let(:remap) do
    {
      Identifier: :something_else,
      :"Alternative Name" => :alternate_name,
      :"Date Created" => :date_created,
      :"Original Language" => :original_language
    }
  end

  it "uses SaveItem service to save all items" do
    expect(SaveItem).to receive(:call).exactly(3).and_return true
    described_class.call(collection_id: 1, items_hash: items, rewrite_rules: [RewriteItemMetadataFields.new])
  end

  it "remaps the id field" do
    allow(SaveItem).to receive(:call).and_return true
    expect(Item).to receive(:new).with(hash_including(user_defined_id: "id1")).ordered
    expect(Item).to receive(:new).with(hash_including(user_defined_id: "id2")).ordered
    expect(Item).to receive(:new).with(hash_including(user_defined_id: "id3")).ordered
    described_class.call(collection_id: 1, items_hash: items, rewrite_rules: [RewriteItemMetadataFields.new])
  end

  it "uses custom mapping when one is given" do
    allow(SaveItem).to receive(:call).and_return true
    expect(Item).to receive(:new).with(hash_including(something_else: "id1")).ordered
    expect(Item).to receive(:new).with(hash_including(something_else: "id2")).ordered
    expect(Item).to receive(:new).with(hash_including(something_else: "id3")).ordered
    described_class.call(collection_id: 1, items_hash: items, rewrite_rules: [RewriteItemMetadataFields.new(field_map: remap)])
  end
end

require "rails_helper"
require "support/item_meta_helpers"

RSpec.configure do |c|
  c.include ItemMetaHelpers, helpers: :item_meta_helpers
end

RSpec.describe RewriteItemMetadata, helpers: :item_meta_helpers do
  let(:item) { item_meta_hash(item_id: 1) }
  let(:remapped_item) { item_meta_hash_remapped(item_id: 1) }

  it "rewrites all fields from labels to field names" do
    expect(described_class.call(item_hash: item)).to eq(remapped_item)
  end

  it "rewrites multiples to an array" do
    item["Alternate Name"] = "name1||name2"
    remapped_item[:alternate_name] = ["name1", "name2"]
    expect(described_class.call(item_hash: item)).to eq(remapped_item)
  end

  it "rewrites dates"
end

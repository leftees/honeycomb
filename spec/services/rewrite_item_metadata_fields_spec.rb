require "rails_helper"
require "support/item_meta_helpers"

RSpec.configure do |c|
  c.include ItemMetaHelpers, helpers: :item_meta_helpers
end

RSpec.describe RewriteItemMetadataFields, helpers: :item_meta_helpers do
  let(:item) { item_meta_hash(item_id: 1) }
  let(:remapped_item) { item_meta_hash_remapped(item_id: 1) }
  let(:remap) do
    {
      id: :something_else,
      alternateName: :alternate_name,
      dateCreated: :date_created,
      originalLanguage: :original_language
    }
  end

  it "remaps the id field" do
    expect(described_class.call(item_hash: item)).to eq(remapped_item)
  end
end

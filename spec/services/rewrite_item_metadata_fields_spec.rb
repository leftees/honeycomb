require "rails_helper"
require "support/item_meta_helpers"

RSpec.configure do |c|
  c.include ItemMetaHelpers, helpers: :item_meta_helpers
end

RSpec.describe RewriteItemMetadataFields, helpers: :item_meta_helpers do
  let(:items) do
    [
      item_meta_hash(item_id: 1),
      item_meta_hash(item_id: 2),
      item_meta_hash(item_id: 3),
    ]
  end
  let(:remap) do
    {
      id: :something_else,
      alternativeName: :alternate_name,
      dateCreated: :date_created,
      originalLanguage: :original_language
    }
  end

  it "by default, maps fields to actual Item fields" do
    described_class.new.default_field_map.each do |_k, v|
      expect(Item.new).to respond_to(v)
    end
  end
end

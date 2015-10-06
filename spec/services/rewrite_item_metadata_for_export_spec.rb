require "rails_helper"
require "support/item_meta_helpers"

RSpec.configure do |c|
  c.include ItemMetaHelpers, helpers: :item_meta_helpers
end

RSpec.describe RewriteItemMetadataForExport, helpers: :item_meta_helpers do
  let(:item) { item_meta_hash_field_names(item_id: 1) }
  let(:remapped_item) { item_meta_hash_remapped_to_labels(item_id: 1) }
  let(:subject) { described_class.call(item_hash: item) }

  it "rewrites all fields from labels to field names" do
    expect(subject).to eq(remapped_item)
  end

  it "rewrites multiples to an array" do
    remapped_item["Alternate Name"] = "name1||name2"
    item[:alternate_name] = ["name1", "name2"]
    expect(subject).to eq(remapped_item)
  end

  context "rewrites dates" do
    it "handles bc date" do
      remapped_item["Date Created"] = "'-2001/01/01"
      item[:date_created] = { "year" => "2001", "month" => "1", "day" => "1", "bc" => true, "display_text" => nil }
      expect(subject).to eq(remapped_item)
    end

    it "adds a string literal indicator" do
      remapped_item["Date Created"] = "'"
      item[:date_created] = { "year" => "", "month" => "", "day" => "", "bc" => false, "display_text" => nil }
      expect(subject).to eq(remapped_item)
    end
  end
end

require "rails_helper"
require "support/item_meta_helpers"

RSpec.configure do |c|
  c.include ItemMetaHelpers, helpers: :item_meta_helpers
end

RSpec.describe RewriteItemMetadata, helpers: :item_meta_helpers do
  let(:item) { item_meta_hash(item_id: 1) }
  let(:remapped_item) { item_meta_hash_remapped(item_id: 1) }
  let(:errors) { [] }
  let(:subject) { described_class.call(item_hash: item, errors: errors) }

  it "rewrites all fields from labels to field names" do
    expect(subject).to eq(remapped_item)
  end

  it "rewrites multiples to an array" do
    item["Alternate Name"] = "name1||name2"
    remapped_item[:alternate_name] = ["name1", "name2"]
    expect(subject).to eq(remapped_item)
  end

  context "rewrites dates" do
    it "handles bc date" do
      item["Date Created"] = "-2001/01/01"
      remapped_item[:date_created] = { "year" => "2001", "month" => "1", "day" => "1", "bc" => true, "display_text" => nil }
      expect(subject).to eq(remapped_item)
    end

    it "can handle string literal indicator" do
      item["Date Created"] = "'-2001/01/01"
      remapped_item[:date_created] = { "year" => "2001", "month" => "1", "day" => "1", "bc" => true, "display_text" => nil }
      expect(subject).to eq(remapped_item)
    end
  end

  it "adds to the given errors array when a label is not found" do
    allow(Item).to receive(:method_defined?).and_return false
    subject
    expected = item.keys.map { |attribute| "Unknown attribute #{attribute}" }
    expect(errors).to eq(expected)
  end
end

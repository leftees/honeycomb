require "rails_helper"
require "support/item_meta_helpers"

RSpec.configure do |c|
  c.include ItemMetaHelpers, helpers: :item_meta_helpers
end

RSpec.describe GoogleCreateItems, helpers: :item_meta_helpers do
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
  let(:item) { instance_double(Item, valid?: true, changed?: false, new_record?: false, errors: []) }
  let(:worksheet) { instance_double(GoogleDrive::Worksheet) }
  let(:param_hash) { { auth_code: "auth", callback_uri: "callback", collection_id: 1, file: "file", sheet: "sheet" } }
  let(:subject) { described_class.call(param_hash) }

  before (:each) do
    allow_any_instance_of(GoogleSession).to receive(:connect)
    allow_any_instance_of(GoogleSession).to receive(:get_worksheet).and_return(worksheet)
    allow_any_instance_of(GoogleSession).to receive(:worksheet_to_hash).and_return(items)
    allow(SaveItem).to receive(:call).and_return true
  end

  it "creates new item with the remapped properties" do
    allow(Item).to receive(:new).and_return(item)
    allow(CreateUniqueId).to receive(:call).and_return(true)
    expect(Item).to receive(:new).with(hash_including(remapped_items[0])).ordered
    expect(Item).to receive(:new).with(hash_including(remapped_items[1])).ordered
    expect(Item).to receive(:new).with(hash_including(remapped_items[2])).ordered
    subject
  end

  it "uses SaveItem service to save all items" do
    allow(Item).to receive(:new).and_return(item)
    allow(CreateUniqueId).to receive(:call).and_return(true)
    expect(SaveItem).to receive(:call).exactly(3).and_return true
    subject
  end

  it "throws an exception if a label is not found" do
    items[0][:InvalidFieldName] = "invalid value"
    expect do
      subject
    end.to raise_error(ActiveRecord::UnknownAttributeError)
  end

  it "uses google api to retrieve the worksheet" do
    expect_any_instance_of(GoogleSession).to receive(:get_worksheet).with(file: param_hash[:file], sheet: param_hash[:sheet]).and_return(worksheet)
    subject
  end

  it "gets the rows of the worksheet" do
    expect_any_instance_of(GoogleSession).to receive(:worksheet_to_hash).and_return({})
    subject
  end

  it "calls create! with the hash read from the worksheet" do
    allow_any_instance_of(GoogleSession).to receive(:worksheet_to_hash).and_return([{ item: "item" }])
    creator = GoogleCreateItems.new(auth_code: param_hash[:auth_code], callback_uri: param_hash[:callback_uri])
    expect(creator).to receive(:create!).with(hash_including(items_hash: [{ item: "item" }]))
    creator.create_from_worksheet!(collection_id: param_hash[:collection_id], file: param_hash[:file], sheet: param_hash[:sheet])
  end

  context "worksheet has items" do
    it "returns a hash with summary" do
      allow_any_instance_of(GoogleSession).to receive(:worksheet_to_hash).and_return(items)
      creator = GoogleCreateItems.new(auth_code: param_hash[:auth_code], callback_uri: param_hash[:callback_uri])
      results = creator.create_from_worksheet!(collection_id: param_hash[:collection_id], file: param_hash[:file], sheet: param_hash[:sheet])
      expected = { summary: { total_count: 3, valid_count: 0, new_count: 0, error_count: 3, changed_count: 0 } }
      expect(results).to include(expected)
    end

    it "returns a hash with errors" do
      allow_any_instance_of(GoogleSession).to receive(:worksheet_to_hash).and_return(items)
      creator = GoogleCreateItems.new(auth_code: param_hash[:auth_code], callback_uri: param_hash[:callback_uri])
      results = creator.create_from_worksheet!(collection_id: param_hash[:collection_id], file: param_hash[:file], sheet: param_hash[:sheet])
      expect(results).to include(:errors)
    end
  end


  context "worksheet has no items" do
    it "returns a hash with summary" do
      allow_any_instance_of(GoogleSession).to receive(:worksheet_to_hash).and_return([])
      creator = GoogleCreateItems.new(auth_code: param_hash[:auth_code], callback_uri: param_hash[:callback_uri])
      results = creator.create_from_worksheet!(collection_id: param_hash[:collection_id], file: param_hash[:file], sheet: param_hash[:sheet])
      expected = { summary: { total_count: 0, valid_count: 0, new_count: 0, error_count: 0, changed_count: 0 } }
      expect(results).to include(expected)
    end

    it "returns a hash with errors" do
      allow_any_instance_of(GoogleSession).to receive(:worksheet_to_hash).and_return([])
      creator = GoogleCreateItems.new(auth_code: param_hash[:auth_code], callback_uri: param_hash[:callback_uri])
      results = creator.create_from_worksheet!(collection_id: param_hash[:collection_id], file: param_hash[:file], sheet: param_hash[:sheet])
      expect(results).to include(errors: [])
    end
  end
end

require "rails_helper"

RSpec.describe CreatePageItemAssociations do
  let(:item1) { instance_double(Item, id: 1, valid?: true) }
  let(:item2) { instance_double(Item, id: 2, valid?: true) }
  let(:item3) { instance_double(Item, id: 3, valid?: true) }
  let(:multi_items) { [item1.id, item2.id, item3.id] }
  let(:page) { instance_double(Page, id: 1, valid?: true) }
  let(:subject) { described_class }
  let(:association_instance) { subject.new(item_ids: multi_items, page_id: page.id) }

  describe ".new" do
    it "requires item_ids" do
      expect(Page).to receive(:find).with(page.id).and_return(page)
      expect { subject.new(page_id: page.id, item_ids: nil) }.to raise_error
      expect { subject.new(page_id: page.id) }.not_to raise_error
    end

    it "requires page_id" do
      expect(Page).to receive(:find).with(page.id).and_return(page)
      expect { subject.new }.to raise_error
      expect { subject.new(page_id: page.id) }.not_to raise_error
    end
  end

  describe ".call" do
    context "when a single item is submitted" do
      it "creates association" do
        expect(Item).to receive(:find).with([item1.id]).and_return([item1])
        expect(Page).to receive(:find).with(page.id).and_return(page)
        expect(page).to receive(:items=).with([item1]).and_return([item1])
        expect(subject.call(item_ids: item1.id, page_id: page.id)).to eq [item1]
      end
    end

    context "when multiple items are submitted" do
      it "creates multiple associations" do
        expect(Item).to receive(:find).with([item1.id, item2.id, item3.id]).and_return([item1, item2, item3])
        expect(Page).to receive(:find).with(page.id).and_return(page)
        expect(page).to receive(:items=).with([item1, item2, item3]).and_return([item1, item2, item3])
        expect(subject.call(item_ids: multi_items, page_id: page.id)).to have(3).items
      end
    end
  end

  describe "#create_array" do
    context "when a single item is submitted" do
      it "creates and returns an array" do
        expect(Item).to receive(:find).with([item1.id, item2.id, item3.id]).and_return([item1, item2, item3])
        expect(Page).to receive(:find).with(page.id).and_return(page)
        expect(association_instance.send(:create_array, item1)).to be_a(Array)
      end
    end

    context "when multiple items are submitted" do
      it "returns the array" do
        expect(Item).to receive(:find).with([item1.id, item2.id, item3.id]).and_return([item1, item2, item3])
        expect(Page).to receive(:find).with(page.id).and_return(page)
        expect(association_instance.send(:create_array, multi_items)).to be_a(Array)
      end
    end
  end
end

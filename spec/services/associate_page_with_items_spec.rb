require "rails_helper"

describe AssociatePageWithItems do
  subject { described_class.call(page) }

  let(:page_content) { File.read(Rails.root.join("spec/fixtures/sample_page_content.txt")) }
  let(:page) { instance_double(Page, id: 1, content: page_content, collection: collection, collection_id: collection.id) }
  let(:item) { Item.new }
  let(:collection) { instance_double(Collection, id: 1) }

  it "calls #associate!" do
    expect_any_instance_of(described_class).to receive(:associate!)
    subject
  end

  context "with a failed transaction" do
    context "when previous item associations are not destroyed" do
      it "will void the transaction" do
        allow(DestroyPageItemAssociations).to receive(:call).with(page_id: page.id).and_raise(Exception)
        expect(CreatePageItemAssociations).not_to receive(:call)
        expect { subject }.to raise_error
      end
    end

    context "when new item associations are not created" do
      it "will void the transaction" do
        expect(DestroyPageItemAssociations).to receive(:call).with(page_id: page.id).and_return(true)
        expect_any_instance_of(described_class).to receive(:derive_item_ids).and_return([])
        expect(CreatePageItemAssociations).to receive(:call).with(item_ids: [], page_id: page.id).and_raise(Exception)
        expect { subject }.to raise_error
      end
    end
  end

  describe "#derive_item_ids!" do
    it "returns the correct item count" do
      expect(ParsePage).to receive(:call).and_return(Nokogiri::HTML(page_content))
      allow(Item).to receive_message_chain(:where, :take!).and_return(item)
      allow_any_instance_of(Nokogiri::XML::Element).to receive_message_chain(:attribute, :value).and_return(1)
      expect(described_class.new(page).send(:derive_item_ids).count).to eq 2
    end
  end
end

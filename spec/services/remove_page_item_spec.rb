require "rails_helper"

describe RemovePageItem do
  subject { described_class.call(page) }

  let(:page_content) { File.read(Rails.root.join("spec/fixtures/sample_page_content.txt")) }
  let(:collection) { Collection.new(id: 1) }
  let(:page) { Page.new(id: 1, content: page_content, collection: collection, collection_id: collection.id) }
  let(:item) { Item.new(unique_id: "ec625c51db", pages: [page]) }
  subject { described_class.call(page, item) }

  it "calls #remove!" do
    expect_any_instance_of(described_class).to receive(:remove!)
    subject
  end

  describe "#remove!" do
    it "removes the item src target from the page" do
      expect(page).to receive(:save!).and_return(true)
      subject
      expect(Nokogiri::HTML::DocumentFragment.parse(page.content).to_html).not_to include("ec625c51db")
    end
  end
end

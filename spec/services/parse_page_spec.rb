require "rails_helper"

describe ParsePage do
  subject { described_class.call(page) }

  let(:page_content) { File.read(Rails.root.join("spec/fixtures/sample_page_content.txt")) }
  let(:page) { instance_double(Page, id: 1, content: page_content, collection: collection, collection_id: collection.id) }
  let(:collection) { instance_double(Collection, id: 1) }

  it "calls #parse!" do
    expect_any_instance_of(described_class).to receive(:parse!)
    subject
  end

  describe "#parse!" do
    it "returns a nokogiri parsed object" do
      expect(subject).to be_kind_of(Nokogiri::HTML::DocumentFragment)
    end

    it "exposes image elements" do
      expect(subject.css(".hc_page_image").count).to eq 2
    end
  end
end

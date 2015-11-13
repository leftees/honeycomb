require "rails_helper"

RSpec.describe V1::PageJSONDecorator do
  subject { described_class.new(page) }

  let(:page) { double(Page) }

  describe "generic fields" do
    [:id, :unique_id, :collection, :updated_at, :name, :content].each do |field|
      it "responds to #{field}" do
        expect(subject).to respond_to(field)
      end
    end
  end

  describe "#at_id" do
    let(:page) { double(Page, unique_id: "page_id") }

    it "returns the path to the id" do
      expect(subject.at_id).to eq("http://test.host/v1/pages/page_id")
    end
  end

  describe "#collection_url" do
    let(:collection) { double(Collection, unique_id: "collection_id") }
    let(:page) { double(Page, collection: collection) }

    it "returns the path to the items" do
      expect(subject.collection_url).to eq("http://test.host/v1/collections/collection_id")
    end
  end

  describe "#slug" do
    let(:page) { double(Page, slug: "sluggish") }

    it "calls the slug generator" do
      expect(CreateURLSlug).to receive(:call).with(page.slug)
      subject.slug
    end
  end

  describe "#display" do
    let(:json) { double }

    it "calls the partial for the display" do
      expect(json).to receive(:partial!).with("/v1/pages/page", page_object: page)
      subject.display(json)
    end
  end

  describe "#next" do
    it "uses the site objects query to retrieve the next object" do
      expect_any_instance_of(SiteObjectsQuery).to receive(:next).with(collection_object: page)
      subject.next
    end
  end

  describe "#previous" do
    it "uses the site objects query to retrieve the previous object" do
      expect_any_instance_of(SiteObjectsQuery).to receive(:previous).with(collection_object: page)
      subject.previous
    end
  end

  it "gives the correct additional_type" do
    expect(subject.additional_type).to eq("https://github.com/ndlib/honeycomb/wiki/Page")
  end
end

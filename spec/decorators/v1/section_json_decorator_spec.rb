require 'rails_helper'

RSpec.describe V1::SectionJSONDecorator do
  subject {described_class.new(section)}

  let(:collection) { double(Collection, id: 1, unique_id: "colasdf", title: 'title title') }
  let(:section) { double(Section, id: 1, description: nil, unique_id: "adsf", caption: 'caption', title: 'title title', collection: collection, showcase: showcase )}
  let(:showcase) { double(Showcase, id: 1, unique_id: "showadsf", title: 'title title')}
  let(:json) { double }

  describe "generic fields" do
    [:id, :title, :caption, :unique_id, :item, :updated_at].each do | field |
      it "responds to #{field}" do
        expect(subject).to respond_to(field)
      end
    end
  end


  describe "#at_id" do

    it "returns the path to the id" do
      expect(subject.at_id).to eq("http://test.host/v1/sections/adsf")
    end
  end

  describe "#collection_url" do

    it "returns the path to the items" do
      expect(subject.collection_url).to eq("http://test.host/v1/collections/colasdf")
    end
  end

  describe "#showcase_url" do

    it "returns the path to the items" do
      expect(subject.showcase_url).to eq("http://test.host/v1/showcases/showadsf")
    end
  end

  describe "#description" do
    it "converts null to empty string" do
      expect(subject.description).to eq("")
    end
  end

  describe "#slug" do

    it "Calls the slug generator" do
      expect(CreateURLSlug).to receive(:call).with(collection.title).and_return('slug')
      expect(subject.slug).to eq("slug")
    end
  end


  describe "#display" do

    it "calls the partial for the display" do
      expect(json).to receive(:partial!).with("/v1/sections/section", {:section_object => section })
      subject.display(json)
    end
  end
end

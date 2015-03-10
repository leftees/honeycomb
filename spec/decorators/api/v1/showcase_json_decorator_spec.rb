require 'rails_helper'

RSpec.describe API::V1::ShowcaseJSONDecorator do
  subject {described_class.new(showcase)}

  let(:collection) { double(Collection, id: 1, unique_id: "colasdf", title: 'title title') }
  let(:showcase) { double(Showcase, id: 1, unique_id: "adsf", title: 'title title', collection: collection )}
  let(:json) { double }

  describe "generic fields" do
    [:id, :title, :description, :unique_id, :image, :updated_at].each do | field |
      it "responds to #{field}" do
        expect(subject).to respond_to(field)
      end
    end
  end


  describe "#at_id" do

    it "returns the path to the id" do
      expect(subject.at_id).to eq("http://test.host/api/v1/showcases/adsf")
    end
  end


  describe "#collection_url" do

    it "returns the path to the items" do
      expect(subject.collection_url).to eq("http://test.host/api/v1/collections/colasdf")
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
      expect(json).to receive(:partial!).with("api/v1/showcases/showcase", {:showcase_object => showcase })
      subject.display(json)
    end
  end
end

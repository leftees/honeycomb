require "rails_helper"

RSpec.describe PageJSONDecorator do
  subject { described_class.new(page) }

  let(:page) { double(Page, id: 1, image: double(Image, image: double(url: "http://nowhere", original_filename: "test", width: 1, height: 1, content_type: "jpeg"))) }

  describe "#at_id" do
    it "returns the path to the id" do
      expect(subject.at_id).to eq("http://test.host/pages/1/edit")
    end
  end

  describe "#image" do
    let(:image) { double(Image) }

    it "returns the correct content url" do
      expect(subject.image["contentUrl"]).to eq("http://nowhere")
    end
    it "returns the name" do
      expect(subject.image["name"]).to eq("test")
    end

    it "returns the small thumbnail image properties" do
      expect(subject.image["thumbnail/small"]["contentUrl"]).to eq("http://nowhere")
      expect(subject.image["thumbnail/small"]["encodingFormat"]).to eq("jpeg")
    end
  end
end

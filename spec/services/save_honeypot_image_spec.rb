require "rails_helper"

RSpec.describe SaveHoneypotImage do
  subject { described_class.new(object: item) }

  let(:honeypot_json) { JSON.parse(File.read(File.join(Rails.root, "spec/fixtures/honeypot_response.json"))) }

  let(:connection) do
    Faraday.new do |builder|
      builder.adapter :test do |stub|
        stub.post("/api/images") { |_env| [200, { content_type: "application/json" }, honeypot_json] }
      end
    end
  end

  let(:failed_connection) do
    Faraday.new do |builder|
      builder.adapter :test do |stub|
        stub.post("/api/images") { |_env| [500, { content_type: "application/json" }, "failed"] }
      end
    end
  end

  let(:honeypot_image) { HoneypotImage.new(item_id: 1) }
  let(:collection) { double(Collection, id: 100, image: image, honeypot_image: honeypot_image, save: true) }
  let(:item) { double(Item, id: 10, collection: collection, image: image, honeypot_image: honeypot_image, save: true) }
  let(:image) { double(path: Rails.root.join("spec/fixtures/test.jpg").to_s, content_type: "image/jpeg") }
  let(:faraday_response) { double(success?: true, body: honeypot_json) }

  describe "successful request" do
    before(:each) do
      expect_any_instance_of(described_class).to receive(:connection).and_return(connection)
    end

    it "sends a request to the json api" do
      expect(connection).to receive(:post).with("/api/images", application_id: "honeycomb", group_id: 100, item_id: 10, image: kind_of(Faraday::UploadIO)).and_return(faraday_response)

      subject.save!
    end

    it "calls the build method if item does not have a honeypot_image" do
      expect(item).to receive(:honeypot_image).and_return(nil)
      expect(item).to receive(:build_honeypot_image).and_return(honeypot_image)

      subject.save!
    end

    describe "result of #save!" do
      let(:service) { described_class.new(object: item) }
      subject { service.save! }

      it "creates a database records when the request is successful" do
        expect(subject).to be_kind_of(HoneypotImage)
        expect(subject).to be_valid
      end

      it "sets a name in the image object" do
        expect(subject.name).to eq("1920x1200.jpeg")
      end

      it "returns a valid url" do
        expect(subject.url).to eq("http://localhost:3019/api/v1/images/test/000/001/000/001/1920x1200.jpeg")
      end

      it "returns false when the honeypot_image does not save" do
        expect_any_instance_of(HoneypotImage).to receive(:save).and_return(false)
        expect(subject).to be(false)
      end

      it "sets the image_status if the object has one" do
        allow(item).to receive(:image_status)
        expect(item).to receive(:image_status=).with("image_ready")
        subject
      end

      it "does not set the image_status if the object does not have one" do
        expect(item).not_to receive(:image_status=)
        subject
      end
    end
  end

  describe "failed request" do
    it "returns false when the request fails" do
      expect_any_instance_of(described_class).to receive(:connection).and_return(failed_connection)
      expect(subject.save!).to eq(false)
    end
  end

  describe "self" do
    subject { described_class }

    describe "#call" do
      it "calls save! on a new instance" do
        expect(subject).to receive(:new).with(object: item).and_call_original
        expect_any_instance_of(described_class).to receive(:save!).and_return("saved!")
        expect(subject.call(object: item)).to eq("saved!")
      end
    end
  end

  describe "#connection" do
    it "is a Faraday connection" do
      connection = subject.send(:connection)
      expect(connection).to be_kind_of(Faraday::Connection)
      expect(connection.url_prefix.to_s).to eq("http://localhost:3019/")
    end
  end

  describe "#api_url" do
    it "returns a url to the honeypot application" do
      expect(subject.send(:api_url)).to eq("http://localhost:3019")
    end
  end

  context "group id" do
    it "uses the collection id as the group id when the object is a collection" do
      subject = described_class.new(object: collection)
      expect(subject.send(:group_id)).to eq(collection.id)
    end

    it "uses the collection id as the group id when the object has a collection method" do
      subject = described_class.new(object: item)
      expect(subject.send(:group_id)).to eq(collection.id)
    end
  end
end

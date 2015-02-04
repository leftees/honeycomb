require "rails_helper"

RSpec.describe SaveHoneypotImage do
  subject { described_class.new(item) }

  let(:honeypot_json) { JSON.parse(File.read(File.join(Rails.root, 'spec/fixtures/honeypot_response.json'))) }

  let(:connection) do
    Faraday.new do |builder|
      builder.adapter :test do |stub|
        stub.post('/api/images') { |env| [ 200, {content_type: 'application/json'}, honeypot_json ]}
      end
    end
  end

  let(:failed_connection) do
    Faraday.new do |builder|
      builder.adapter :test do |stub|
        stub.post('/api/images') { |env| [ 500, {content_type: 'application/json'}, "failed" ]}
      end
    end
  end

  let(:honeypot_image) { HoneypotImage.new(item_id: 1) }
  let(:item) { double(Item, id: 1, collection_id: 1, image: image, honeypot_image: honeypot_image) }
  let(:image) { double(path: Rails.root.join("spec/fixtures/test.jpg").to_s, content_type: 'image/jpeg') }
  let(:faraday_response) { double( success?: true, body: honeypot_json )}

  describe "successful request" do

    before(:each) do
      expect_any_instance_of(described_class).to receive(:connection).and_return(connection)
    end

    it "sends a request to the json api" do
      expect(connection).to receive(:post).with('/api/images', { :application_id=>"honeycomb", :group_id=>1, :item_id=>1, image: kind_of(Faraday::UploadIO) }).and_return(faraday_response)

      subject.save!
    end

    it "calls the build method if item does not have a honeypot_image" do
      expect(item).to receive(:honeypot_image).and_return(nil)
      expect(item).to receive(:build_honeypot_image).and_return(honeypot_image)

      subject.save!
    end

    describe 'result of #save!' do
      let(:service) { described_class.new(item) }
      subject { service.save! }

      it "creates a database records when the request is successful" do
        expect(subject).to be_kind_of(HoneypotImage)
        expect(subject).to be_valid
      end

      it "sets a host in the image object" do
        expect(subject.host).to eq("localhost")
      end

      it "sets a title in the image object" do
        expect(subject.title).to eq("1920x1200.jpeg")
      end

      it "creates a style" do
        original = subject.style(:original)
        expect(original.width).to eq(1920)
        expect(original.height).to eq(1200)
      end

      it "returns false when the honeypot_image does not save" do
        expect_any_instance_of(HoneypotImage).to receive(:save).and_return(false)
        expect(subject).to be(false)
      end
    end
  end

  describe "failed request" do
    it "returns false when the request fails" do
      expect_any_instance_of(described_class).to receive(:connection).and_return(failed_connection)
      expect(subject.save!).to eq(false)
    end
  end

  describe 'self' do
    subject { described_class }

    describe '#call' do
      it "calls save! on a new instance" do
        expect(subject).to receive(:new).with(item).and_call_original
        expect_any_instance_of(described_class).to receive(:save!).and_return('saved!')
        expect(subject.call(item)).to eq('saved!')
      end
    end
  end
end

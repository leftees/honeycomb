require "rails_helper"

RSpec.describe HoneypotImage, type: :model do
  let(:honeypot_json) { JSON.parse(File.read(File.join(Rails.root, "spec/fixtures/honeypot_response.json"))) }
  [:json_response, :name, :item, :showcase, :collection].each do |field|
    it "has field, #{field}" do
      expect(subject).to respond_to(field)
      expect(subject).to respond_to("#{field}=")
    end
  end

  [:json_response, :name].each do |field|
    it "validates the #{field}" do
      expect(subject).to have(1).error_on(field)
    end
  end

  describe "#image_json" do
    it "is the image value from the json" do
      subject.json_response = honeypot_json
      expect(subject.image_json).to eq(honeypot_json)
    end

    it "is an empty hash if the json_response is not present" do
      expect(subject.image_json).to eq({})
    end
  end

  describe "#json_response=" do
    it "sets the name from the json" do
      expect(subject.name).to be_nil
      subject.json_response = honeypot_json
      expect(subject.name).to eq("1920x1200.jpeg")
    end
  end

  it "has a papertrail" do
    expect(subject).to respond_to(:paper_trail_enabled_for_model?)
    expect(subject.paper_trail_enabled_for_model?).to be(true)
  end
end

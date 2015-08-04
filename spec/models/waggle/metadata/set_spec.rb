require "rails_helper"

RSpec.describe Waggle::Metadata::Set do
  let(:item_id) { "pig-in-mud" }
  let(:raw_data) { File.read(Rails.root.join("spec/fixtures/v1/items/#{item_id}.json")) }
  let(:data) { JSON.parse(raw_data).fetch("items").fetch("metadata") }
  let(:configuration) { Metadata::Configuration.item_configuration }

  subject { described_class.new(data, configuration) }

  describe "field?" do
    it "is true for a field that exists" do
      expect(subject.field?(:name)).to eq(true)
    end

    it "is false for a field that doesn't exist" do
      expect(subject.field?(:fake_field)).to eq(false)
    end
  end

  describe "value" do
    it "returns the value in an array" do
      expect(subject.value(:name)).to eq(["pig-in-mud"])
    end

    it "returns nil for a field with no value" do
      data.delete("name")
      expect(subject.value(:name)).to be_nil
    end

    it "returns nil for a field that doesn't exist" do
      expect(subject.value(:fake_field)).to be_nil
    end
  end
end

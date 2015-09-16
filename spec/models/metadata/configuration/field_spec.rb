require "rails_helper"

RSpec.describe Metadata::Configuration::Field do
  let(:data) { { name: :string_field, type: :string, label: "String", defaultFormField: true, optionalFormField: false, order: true } }

  subject { described_class.new(data) }

  describe "name" do
    it "is the expected value" do
      expect(subject.name).to eq(data[:name])
    end
  end

  describe "type" do
    it "is the expected value" do
      expect(subject.type).to eq(data[:type])
    end

    described_class::TYPES.each do |type|
      it "can be '#{type}'" do
        data[:type] = type
        expect(subject.type).to eq(type)
      end
    end

    it "cannot be an unknown type" do
      data[:type] = :fake_type
      expect { subject }.to raise_error(ArgumentError)
    end
  end

  describe "label" do
    it "is the expected value" do
      expect(subject.label).to eq(data[:label])
    end
  end

  describe "defaultFormField" do
    it "is the expected value" do
      expect(subject.defaultFormField).to eq(data[:defaultFormField])
    end
  end

  describe "optionalFormField" do
    it "is the expected value" do
      expect(subject.optionalFormField).to eq(data[:optionalFormField])
    end
  end

  describe "order" do
    it "is the expected value" do
      expect(subject.order).to eq(data[:order])
    end
  end

  describe "to_json" do
    it "converts default_form_field to defaultFormField"

    it "convertes the key option_form_field to optionalFormField"
  end
end

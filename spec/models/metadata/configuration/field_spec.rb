require "rails_helper"

RSpec.describe Metadata::Configuration::Field do
  let(:data) do
    {
      name: :string_field,
      type: :string,
      label: "String",
      placeholder: "placeholder",
      help: "help",
      default_form_field: true,
      optional_form_field: false,
      order: true
    }
  end

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

  describe "placeholder" do
    it "is the expected value" do
      expect(subject.placeholder).to eq(data[:placeholder])
    end
  end

  describe "help" do
    it "is the expected value" do
      expect(subject.help).to eq(data[:help])
    end
  end

  describe "default_form_field" do
    it "is the expected value" do
      expect(subject.default_form_field).to eq(data[:default_form_field])
    end
  end

  describe "optional_form_field" do
    it "is the expected value" do
      expect(subject.optional_form_field).to eq(data[:optional_form_field])
    end
  end

  describe "order" do
    it "is the expected value" do
      expect(subject.order).to eq(data[:order])
    end
  end

  describe "to_json" do
    it "converts default_form_field to defaultFormField" do
      expect(subject.to_json).to include("defaultFormField")
      expect(subject.to_json).to_not include("default_form_field")
    end

    it "convertes the key option_form_field to optionalFormField" do
      expect(subject.to_json).to include("optionalFormField")
      expect(subject.to_json).to_not include("option_form_field")
    end
  end
end

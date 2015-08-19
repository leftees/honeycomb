require "rails_helper"

RSpec.describe Metadata::Configuration do
  let(:data) do
    {
      fields: [
        { name: :string_field, type: :string, label: "String" },
        { name: :date_field, type: :date, label: "Date" },
      ]
    }
  end
  let(:instance) { described_class.new(data) }

  subject { instance }

  describe "field" do
    it "finds a field by its name" do
      field = subject.field(:string_field)
      expect(field).to be_kind_of(described_class::Field)
      expect(field.name).to eq(:string_field)
    end

    it "returns nil if a field doesn't exist" do
      expect(subject.field(:fake_field)).to be_nil
    end
  end

  describe "field?" do
    it "returns true for a field that exists" do
      expect(subject.field?(:string_field)).to eq(true)
    end

    it "returns nil if a field doesn't exist" do
      expect(subject.field?(:fake_field)).to eq(false)
    end
  end
  describe "label" do
    it "finds a field by its label" do
      field = subject.label("String")
      expect(field).to be_kind_of(described_class::Field)
      expect(field.label).to eq("String")
    end

    it "returns nil if a label doesn't exist" do
      expect(subject.label("fake_field")).to be_nil
    end
  end

  describe "label?" do
    it "returns true for a field that exists" do
      expect(subject.label?("String")).to eq(true)
    end

    it "returns nil if a field doesn't exist" do
      expect(subject.label?("fake_field")).to eq(false)
    end
  end

  describe "fields" do
    subject { instance.fields }

    it "is an array of fields" do
      expect(described_class::Field).to receive(:new).with(data.fetch(:fields)[0]).and_call_original
      expect(described_class::Field).to receive(:new).with(data.fetch(:fields)[1]).and_call_original
      expect(subject).to be_kind_of(Array)
      expect(subject.first).to be_kind_of(described_class::Field)
    end
  end

  context "self" do
    describe "item_configuration" do
      subject { described_class.item_configuration }

      after do
        described_class.instance_variable_set :@item_configuration, nil
      end

      it "loads configuration from a yml file" do
        described_class.instance_variable_set :@item_configuration, nil
        expect(YAML).to receive(:load_file).with(Rails.root.join("config/metadata/", "item.yml")).and_return(fields: [])
        expect(subject.fields).to eq([])
      end

      it "returns a configuration with an array of fields" do
        expect(subject).to be_kind_of(described_class)
        expect(subject.fields.first).to be_kind_of(described_class::Field)
      end

      it "maps fields to actual Item fields" do
        subject.fields.each do |field|
          expect(Item.new).to respond_to(field.name)
        end
      end
    end
  end
end

require "rails_helper"

RSpec.describe Metadata::Configuration do
  let(:data) do
    [
      { name: :string_field, type: :string, label: "String" },
      { name: :date_field, type: :date, label: "Date" },
    ]
  end

  subject { described_class.new(data) }

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

  context "self" do
    describe "build_fields" do
      subject { described_class.build_fields(data) }

      it "creates an array of fields" do
        expect(described_class::Field).to receive(:new).with(data[0]).and_call_original
        expect(described_class::Field).to receive(:new).with(data[1]).and_call_original
        expect(subject).to be_kind_of(Array)
        expect(subject.first).to be_kind_of(described_class::Field)
      end
    end

    describe "item_configuration" do
      subject { described_class.item_configuration }

      after do
        described_class.instance_variable_set :@item_configuration, nil
      end

      it "loads configuration from a yml file" do
        described_class.instance_variable_set :@item_configuration, nil
        expect(YAML).to receive(:load_file).with(Rails.root.join("config/metadata/", "item.yml")).and_return([])
        expect(subject.fields).to eq([])
      end

      it "returns a configuration with an array of fields" do
        expect(subject).to be_kind_of(described_class)
        expect(subject.fields.first).to be_kind_of(described_class::Field)
      end
    end
  end
end

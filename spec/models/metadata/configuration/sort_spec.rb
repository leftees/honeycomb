require "rails_helper"

RSpec.describe Metadata::Configuration::Sort do
  let(:field) { instance_double(Metadata::Configuration::Field, name: :my_field, label: "Default Label") }
  let(:data) { { name: :my_sort, field_name: :my_field, field: field, direction: :asc, label: "Custom Label" } }
  let(:instance) { described_class.new(data) }
  subject { instance }

  describe "name" do
    it "is the expected value" do
      expect(subject.name).to eq(data.fetch(:name))
    end
  end

  describe "field" do
    it "is the expected value" do
      expect(subject.field).to eq(data.fetch(:field))
    end
  end

  describe "direction" do
    it "is the expected value" do
      expect(subject.direction).to eq(data.fetch(:direction))
    end
  end

  describe "field_name" do
    it "is the expected value" do
      expect(subject.field_name).to eq(data.fetch(:field_name))
    end
  end

  describe "label" do
    it "is the expected value" do
      expect(subject.label).to eq(data.fetch(:label))
    end

    it "defaults to the field label" do
      data[:label] = nil
      expect(subject.label).to eq(field.label)
    end
  end
end

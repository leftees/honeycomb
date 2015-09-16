require "rails_helper"

RSpec.describe Metadata::Configuration::Facet do
  let(:field) { instance_double(Metadata::Configuration::Field, name: :my_field, label: "Default Label")}
  let(:data) { { name: :my_facet, field: field, label: "Custom Label" } }
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

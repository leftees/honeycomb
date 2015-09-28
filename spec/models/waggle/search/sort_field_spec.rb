require "rails_helper"

RSpec.describe Waggle::Search::SortField do
  let(:sort_config) { instance_double(Metadata::Configuration::Sort, name: "creatorasc", label: "Creator") }
  subject { described_class.new(name: "Name", value: "nameasc") }

  describe "name" do
    it "is the name" do
      expect(subject.name).to eq("Name")
    end
  end

  describe "value" do
    it "is the value" do
      expect(subject.value).to eq("nameasc")
    end
  end

  describe "self.from_config" do
    subject { described_class.from_config(sort_config) }

    it "creates an instance with the expected values" do
      expect(subject).to be_kind_of(described_class)
      expect(subject.name).to eq("Creator")
      expect(subject.value).to eq("creatorasc")
    end
  end
end

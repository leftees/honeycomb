require "rails_helper"

RSpec.describe Metadata::ConfigurationInputCleaner do
  let(:data) { {} }

  subject { described_class.call(data) }

  it "converts string keys data to symbols" do
    data["field"] = "data"
    expect(subject).to eq(field: "data")
  end

  it "downcases labels into the name " do
    data[:label] = "Name"
    expect(subject).to eq(label: "Name", name: "name")
  end

  it "creates a name out of the label" do
    data[:label] = "Name"
    expect(subject).to eq(label: "Name", name: "name")
  end

  it "underscores spaces in the label to names" do
    data[:label] = "na me"
    expect(subject).to eq(label: "na me", name: "na_me")
  end

  [:required, :default_form_field, :optional_form_field].each do |key|
    it "converts string \"true\" types for #{key} to true" do
      data[key] = "true"
      expect(subject).to eq(key => true)
    end

    it "converts string \"false\" types for #{key} to false" do
      data[key] = "false"
      expect(subject).to eq(key => false)
    end

    it "converts string \"\" types for #{key} to false" do
      data[key] = ""
      expect(subject).to eq(key => false)
    end

    it "retuns true for types #{key} to true" do
      data[key] = true
      expect(subject).to eq(key => true)
    end

    it "retuns false for types #{key} to false" do
      data[key] = false
      expect(subject).to eq(key => false)
    end
  end
end

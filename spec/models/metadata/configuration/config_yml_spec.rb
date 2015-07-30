require "rails_helper"

RSpec.describe Metadata::Configuration do
  Dir.glob(Rails.root.join("config/metadata/*.yml")).each do |path|
    describe path do
      let(:data) { YAML.load_file(path) }

      subject { described_class.new(data) }

      it "is valid" do
        expect(subject.fields).to be_kind_of(Array)
        expect(subject.fields.first).to be_kind_of(described_class::Field)
      end

      it "doesn't contain duplicate fields" do
        fields = data.map { |hash| hash[:name] }
        expect(fields).to eq(fields.uniq)
      end
    end
  end
end

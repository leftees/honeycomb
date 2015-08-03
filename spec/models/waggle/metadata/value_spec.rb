require "rails_helper"

RSpec.describe Waggle::Metadata::Value do
  let(:data) { { "@type" => "MetadataString", "value" => "Bob Smith" } }

  describe "from_hash" do
    subject { described_class.from_hash(data) }

    it "returns a value" do
      expect(subject).to be_kind_of(described_class::Base)
    end

    it "returns a value based on type"
  end
end

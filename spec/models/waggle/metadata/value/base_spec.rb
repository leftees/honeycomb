require "rails_helper"

RSpec.describe Waggle::Metadata::Value::Base do
  let(:data) { { "@type" => "MetadataString", "value" => "Bob Smith" } }

  subject { described_class.new(data) }

  it "works"
end

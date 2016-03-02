RSpec.describe MetadataInputCleaner do
  let(:metadata) { {} }
  let(:item) { instance_double(Item, metadata: metadata) }
  subject { described_class.call(item) }

  it "convertes a string to an array" do
    metadata[:string] = "string"
    subject
    expect(item.metadata["string"]).to eq(["string"])
  end

  it "convertes a javascript array hashs of 0 => { } hash to an array" do
    metadata[:hash] = { "0" => "YES" }
    subject
    expect(item.metadata["hash"]).to eq(["YES"])
  end

  it "converts a regular hash not the special case \"0\" hash" do
    metadata[:hash] = { "key" => "YES" }
    subject
    expect(item.metadata["hash"]).to eq(["key" => "YES"])
  end

  it "does nothing to an existing array" do
    metadata[:array] = ["array"]
    subject
    expect(item.metadata["array"]).to eq(["array"])
  end

  it "removes nil values and their associated key" do
    metadata[:nil] = nil
    subject
    expect(item.metadata.has_key?(:nil)).to eq(false)
  end

  it "removes empty arrays and their associated key" do
    metadata[:array] = []
    subject
    expect(item.metadata.has_key?(:array)).to eq(false)
  end

  it "converts symbols to stings" do
    metadata[:string] = "string"
    subject
    expect(item.metadata["string"]).to eq(["string"])
  end
end

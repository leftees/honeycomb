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

  it "does nothing to an existing array" do
    metadata[:array] = ["array"]
    subject
    expect(item.metadata["array"]).to eq(["array"])
  end

  it "converts value of nil to empty array" do
    metadata[:nil] = nil
    subject
    expect(item.metadata["nil"]).to eq([])
  end

  it "converts symbols to stings" do
    metadata[:string] = "string"
    subject
    expect(item.metadata["string"]).to eq(["string"])
  end
end

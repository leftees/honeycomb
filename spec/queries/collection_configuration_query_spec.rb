require "rails"

describe CollectionConfigurationQuery do
  subject { described_class.new(collection) }
  let(:collection) { double(Collection) }

  it "passes the call to the colllection's collection_configuration on the " do
    expect(collection).to receive(:collection_configuration)
    subject.config
  end

  it "returns the current collection's config" do
    allow(collection).to receive(:collection_configuration).and_return("CONFIG!")
    expect(subject.config).to eq("CONFIG!")
  end
end

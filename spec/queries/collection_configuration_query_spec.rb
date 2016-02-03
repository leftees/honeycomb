require "rails"

describe CollectionConfigurationQuery do
  subject { described_class.new(collection) }
  let(:collection) { double(Collection) }

  it "passes the call to the colllection's collection_configuration on the " do
    expect(collection).to receive(:collection_configuration)
    subject.find
  end

  it "passes the current collection's config to the Metadata::Configuration" do
    allow(collection).to receive(:collection_configuration).and_return("CONFIG!")
    expect(Metadata::Configuration).to receive(:set_item_configuration).with("CONFIG!")
    subject.find
  end
end

describe "CollectionIsPublished" do
  let(:collection) { Collection.new }
  subject { CollectionIsPublished }

  it "indicates a published status" do
    collection.published = true
    expect(subject.new(collection).published?).to be_truthy
  end

  it "indicates a unpublished status" do
    expect(subject.new(collection).published?).to be_falsey
  end

end

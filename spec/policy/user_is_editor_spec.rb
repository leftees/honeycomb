describe UserIsEditor do
  let(:instance) { described_class.new(user, collection) }
  subject { described_class.call(user, collection) }
  let(:user) { double(User, id: "1") }
  let(:collection) { double(Collection, id: "2") }

  it "returns when a CollectionUser is found" do
    allow_any_instance_of(described_class).to receive(:collection_user).and_return(true)
    expect(subject).to be(true)
  end

  it "returns false when a CollectionUser is not found" do
    allow_any_instance_of(described_class).to receive(:collection_user).and_return(nil)
    expect(subject).to be(false)
  end

  it "has a collection_user" do
    expect(CollectionUser).to receive(:where).with(collection_id: collection.id, user_id: user.id).and_call_original
    expect(instance.send(:collection_user)).to be_nil
  end
end

require "rails_helper"

describe RemoveUserFromCollection do
  subject { described_class.new(collection, user) }
  let(:collection_user) { instance_double(CollectionUser, user_id: 1, collection_id: 1)}
  let(:collection) { double(Collection, id: 1) }
  let(:user) { double(User, id: 1) }

  before(:each) do
    allow_any_instance_of(CollectionUser).to receive(:save).and_return(true)
    allow(CollectionUser).to receive(:find_by!).and_return(collection_user)
    AssignUserToCollection.call(collection, user)
  end

  it "deletes the collection_user" do
    expect(collection_user).to receive(:destroy!)
    subject.destroy!
  end

  it "uses the Destroy::CollectionUser.destroy! method" do
    expect_any_instance_of(Destroy::CollectionUser).to receive(:destroy!)
    subject.destroy!
  end
end

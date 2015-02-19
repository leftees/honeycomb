require 'rails_helper'

describe CollectionQuery do
  subject {described_class.new(relation)}
  let(:relation) { Collection.all }
  let(:user) { double(User)}

  describe "for_curator" do

    it "returns all the collections for an admin" do
      expect(UserIsAdmin).to receive(:call).and_return(true)
      expect(relation).to receive(:all)

      subject.for_curator(user)
    end

    it "returns just the users for a non admin" do
      expect(UserIsAdmin).to receive(:call).and_return(false)
      expect(user).to receive(:collections)

      subject.for_curator(user)
    end
  end

  describe "find" do

    it "finds the collection" do
      expect(relation).to receive(:find).with(1)
      subject.find(1)
    end
  end


  describe "build" do

    it "builds a collection off of the relation" do
      expect(relation).to receive(:build)
      subject.build
    end
  end
end

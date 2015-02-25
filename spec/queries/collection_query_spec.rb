require 'rails_helper'

describe CollectionQuery do
  subject {described_class.new(relation)}
  let(:relation) { Collection.all }
  let(:user) { double(User, username: 'username')}
  let(:collection) {double(Collection, id: 1)}

  describe "for_top_nav" do
    before(:each) do
      allow(subject).to receive(:for_curator).and_return(relation)
    end

    it "calls for_curator with the user" do
      expect(subject).to receive(:for_curator).with(user)
      subject.for_top_nav(user, collection)
    end

    it "calls recent with the default options" do
      expect(relation).to receive(:order).and_return(relation)
      subject.for_top_nav(user, collection)
    end

    it "excludes the passed in collection" do
      expect(relation).to receive(:where).and_return(relation)
      expect(relation).to receive(:not).with(id: collection.id).and_return(relation)
      subject.for_top_nav(user, collection)
    end
  end

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

  describe '#recent' do
    it 'orders by update date' do
      expect(relation).to receive(:order).with( { updated_at: :desc } ).and_return(relation)
      subject.recent()
    end

    it "limits to the amount passed in " do
      expect(relation).to receive(:limit).with(10).and_return(relation)
      subject.recent(10)
    end

    it "limits to the default amount" do
      expect(relation).to receive(:limit).with(5).and_return(relation)
      subject.recent()
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

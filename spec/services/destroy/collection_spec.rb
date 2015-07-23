require "rails_helper"

describe Destroy::Collection do
  describe "#cascade" do
    let(:destroy_item) { instance_double(Destroy::Item, cascade!: nil) }
    let(:destroy_exhibit) { instance_double(Destroy::Exhibit, cascade!: nil) }
    let(:destroy_collection_user) { instance_double(Destroy::CollectionUser, cascade!: nil) }
    let(:subject) { Destroy::Collection.new(destroy_collection_user: destroy_collection_user, destroy_item: destroy_item, destroy_exhibit: destroy_exhibit) }
    let(:exhibit) { instance_double(Exhibit, destroy!: true, showcases: []) }
    let(:item) { instance_double(Item, destroy!: true, sections: [], children: []) }
    let(:collection) do
      instance_double(Collection,
                      collection_users: [collection_user, collection_user],
                      exhibit: exhibit,
                      items: [item, item],
                      destroy!: true)
    end
    let(:collection_user) { instance_double(CollectionUser) }

    it "calls DestroyItem.cascade on all associated items" do
      expect(destroy_item).to receive(:cascade!).with(item: item).twice
      subject.cascade!(collection: collection)
    end

    it "calls DestroyExhibit.cascade on all associated exhibits" do
      expect(destroy_exhibit).to receive(:cascade!).with(exhibit: exhibit).once
      subject.cascade!(collection: collection)
    end

    it "calls DestroyExhibit then DestroyItem to prevent FK constraints on Item->Section" do
      expect(destroy_exhibit).to receive(:cascade!).with(exhibit: exhibit).at_least(:once).ordered
      expect(destroy_item).to receive(:cascade!).with(item: item).at_least(:once).ordered
      subject.cascade!(collection: collection)
    end

    it "calls DestroyCollectionUser.cascade on all associated collection_users" do
      expect(destroy_collection_user).to receive(:cascade!).with(collection_user: collection_user).twice
      subject.cascade!(collection: collection)
    end

    it "destroys the Collection" do
      expect(collection).to receive(:destroy!)
      subject.cascade!(collection: collection)
    end
  end

  context "cascade transaction" do
    let(:destroy_item) { Destroy::Item.new }
    let(:destroy_exhibit) { Destroy::Exhibit.new }
    let(:destroy_collection_user) { Destroy::CollectionUser.new }
    let(:subject) { Destroy::Collection.new(destroy_collection_user: destroy_collection_user, destroy_item: destroy_item, destroy_exhibit: destroy_exhibit) }
    let(:collection) { FactoryGirl.create(:collection) }
    let(:exhibit) { FactoryGirl.create(:exhibit, collection_id: collection.id) }
    let(:user) { FactoryGirl.create(:user) }
    let(:collection_users) do
      [FactoryGirl.create(:collection_user, id: 1, collection_id: collection.id),
       FactoryGirl.create(:collection_user, id: 2, collection_id: collection.id)]
    end
    let(:items) do
      [FactoryGirl.create(:item, id: 1, collection_id: collection.id),
       FactoryGirl.create(:item, id: 2, collection_id: collection.id)]
    end

    before(:each) do
      user
      collection
      exhibit
      items
      collection_users
    end

    # Ensures all data that was created still exists
    # in the database
    def data_still_exists!
      items.each do |item|
        expect { item.reload }.not_to raise_error
      end
      collection_users.each do |collection_user|
        expect { collection_user.reload }.not_to raise_error
      end
      expect { exhibit.reload }.not_to raise_error
      expect { collection.reload }.not_to raise_error
    end

    it "rolls back if an error occurs with Destroy::CollectionUser" do
      # Throw error on second object to allow first one to get deleted
      allow(collection).to receive(:collection_users).and_return(collection_users)
      allow(collection_users[1]).to receive(:destroy!).and_raise("error")
      expect { subject.cascade!(collection: collection) }.to raise_error("error")
      data_still_exists!
    end

    it "rolls back if an error occurs with Destroy::Item" do
      # Throw error on second object to allow first one to get deleted
      allow(collection).to receive(:items).and_return(items)
      allow(items[1]).to receive(:destroy!).and_raise("error")
      expect { subject.cascade!(collection: collection) }.to raise_error("error")
      data_still_exists!
    end

    it "rolls back if an error occurs with Destroy::Exhibit" do
      allow(destroy_exhibit).to receive(:cascade!).with(exhibit: exhibit).and_raise("error")
      expect { subject.cascade!(collection: collection) }.to raise_error("error")
      data_still_exists!
    end

    it "rolls back if an error occurs with Collection.destroy!" do
      allow(collection).to receive(:destroy!).and_raise("error")
      expect { subject.cascade!(collection: collection) }.to raise_error("error")
      data_still_exists!
    end
  end
end

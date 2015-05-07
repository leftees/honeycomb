require "rails_helper"

RSpec.describe CacheKeys::Custom::Editors do
  context "index" do
    let(:collection) { instance_double(Collection, collection_users: "collection_users" ) }

    it "uses CacheKeys::ActiveRecord" do
      expect_any_instance_of(CacheKeys::ActiveRecord).to receive(:generate)
      subject.index(collection: collection)
    end

    it "uses the correct data" do
      expect_any_instance_of(CacheKeys::ActiveRecord).to receive(:generate).with(record: [collection, collection.collection_users])
      subject.index(collection: collection)
    end
  end

  context "user_search" do
    let(:collection) { instance_double(Collection, collection_users: "collection_users" ) }
    let(:formatted_users) { [{ id: 1, label: "one", value: "one" }, { id: 2, label: "two", value: "two" }] }

    it "uses CacheKeys::ActiveRecord" do
      expect_any_instance_of(CacheKeys::ActiveRecord).to receive(:generate)
      subject.user_search(collection: collection, formatted_users: formatted_users)
    end

    it "uses the correct data" do
      expect_any_instance_of(CacheKeys::ActiveRecord).to receive(:generate).with(record: [collection, formatted_users])
      subject.user_search(collection: collection, formatted_users: formatted_users)
    end
  end
end

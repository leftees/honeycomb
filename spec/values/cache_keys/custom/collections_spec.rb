require "rails_helper"

RSpec.describe CacheKeys::Custom::Collections do
  context "index" do
    let(:collections) { instance_double(Collection) }

    it "uses CacheKeys::DecoratedActiveRecord" do
      expect_any_instance_of(CacheKeys::ActiveRecord).to receive(:generate)
      subject.index(collections: collections)
    end

    it "uses the correct data" do
      expect_any_instance_of(CacheKeys::ActiveRecord).to receive(:generate).with(record: collections)
      subject.index(collections: collections)
    end
  end

  context "edit" do
    let(:collection) { instance_double(Collection) }

    it "uses CacheKeys::ActiveRecord" do
      expect_any_instance_of(CacheKeys::ActiveRecord).to receive(:generate)
      subject.edit(collection: collection)
    end

    it "uses the correct data" do
      expect_any_instance_of(CacheKeys::ActiveRecord).to receive(:generate).with(record: collection)
      subject.edit(collection: collection)
    end
  end
end

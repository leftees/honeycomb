require "rails_helper"

RSpec.describe CacheKeys::Custom::Pages do
  context "index" do
    let(:collection) { instance_double(Collection, pages: "pages") }

    it "uses CacheKeys::ActiveRecord" do
      expect_any_instance_of(CacheKeys::ActiveRecord).to receive(:generate)
      subject.index(collection: collection)
    end

    it "uses the correct data" do
      expect_any_instance_of(CacheKeys::ActiveRecord).to receive(:generate).with(record: [collection, collection.pages])
      subject.index(collection: collection)
    end
  end

  context "edit" do
    let(:page) { instance_double(Page, collection: "collection") }

    it "uses CacheKeys::ActiveRecord" do
      expect_any_instance_of(CacheKeys::ActiveRecord).to receive(:generate)
      subject.edit(page: page)
    end

    it "uses the correct data" do
      expect_any_instance_of(CacheKeys::ActiveRecord).to receive(:generate).with(record: [page, page.collection])
      subject.edit(page: page)
    end
  end
end

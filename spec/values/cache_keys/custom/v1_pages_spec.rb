require "rails_helper"

RSpec.describe CacheKeys::Custom::V1Pages do
  context "index" do
    let(:collection) { instance_double(Collection, pages: "pages") }

    it "uses CacheKeys::ActiveRecord" do
      expect_any_instance_of(CacheKeys::ActiveRecord).to receive(:generate)
      subject.index(collection: collection)
    end

    it "uses the correct data" do
      expect_any_instance_of(CacheKeys::ActiveRecord).to receive(:generate).with(record: [collection, "pages"])
      subject.index(collection: collection)
    end
  end

  context "show" do
    let(:page) { instance_double(Page, collection: "collection") }
    let(:page_json) do
      instance_double(V1::PageJSONDecorator,
                      collection: "collection",
                      next: "next",
                      object: page)
    end

    it "uses CacheKeys::ActiveRecord" do
      expect_any_instance_of(CacheKeys::ActiveRecord).to receive(:generate)
      subject.show(page: page_json)
    end

    it "uses the correct data" do
      expect_any_instance_of(CacheKeys::ActiveRecord).
        to receive(:generate).
        with(record: [page, page_json.collection, page_json.next])
      subject.show(page: page_json)
    end
  end
end

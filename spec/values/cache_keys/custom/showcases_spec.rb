require "rails_helper"

RSpec.describe CacheKeys::Custom::Showcases do
  context "index" do
    let(:exhibit) { instance_double(Exhibit, showcases: "showcases", collection: "collection" ) }

    it "uses CacheKeys::ActiveRecord" do
      expect_any_instance_of(CacheKeys::ActiveRecord).to receive(:generate)
      subject.index(exhibit: exhibit)
    end

    it "uses the correct data" do
      expect_any_instance_of(CacheKeys::ActiveRecord).to receive(:generate).with(record: [exhibit.showcases, exhibit.collection])
      subject.index(exhibit: exhibit)
    end
  end

  context "default" do
    let(:showcase) { instance_double(Showcase, collection: "collection" ) }

    it "uses CacheKeys::ActiveRecord" do
      expect_any_instance_of(CacheKeys::ActiveRecord).to receive(:generate)
      subject.default(showcase: showcase)
    end

    it "uses the correct data" do
      expect_any_instance_of(CacheKeys::ActiveRecord).to receive(:generate).with(record: [showcase, showcase.collection])
      subject.default(showcase: showcase)
    end
  end

end

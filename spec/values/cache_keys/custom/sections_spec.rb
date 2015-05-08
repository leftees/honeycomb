require "rails_helper"

RSpec.describe CacheKeys::Custom::Sections do
  context "edit" do
    let(:section) { instance_double(Section, collection: "collection") }

    it "uses CacheKeys::ActiveRecord" do
      expect_any_instance_of(CacheKeys::ActiveRecord).to receive(:generate)
      subject.edit(section: section)
    end

    it "uses the correct data" do
      expect_any_instance_of(CacheKeys::ActiveRecord).to receive(:generate).with(record: [section, section.collection])
      subject.edit(section: section)
    end
  end
end

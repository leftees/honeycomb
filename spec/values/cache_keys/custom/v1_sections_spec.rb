require "rails_helper"

RSpec.describe CacheKeys::Custom::V1Sections do


  context "show" do
    let(:decorated_section) { instance_double(V1::SectionJSONDecorator, object: "object", item: "item", item_children: "item_children", next: "next", previous: "previous", collection: "collection", showcase: "showcase") }

    it "uses CacheKeys::ActiveRecord" do
      expect_any_instance_of(CacheKeys::ActiveRecord).to receive(:generate)
      subject.show(decorated_section: decorated_section)
    end

    it "uses the correct data" do
      expect_any_instance_of(CacheKeys::ActiveRecord).to receive(:generate).with({ record: ["object", "item", "item_children", "next", "previous", "collection", "showcase"] })
      subject.show(decorated_section: decorated_section)
    end
  end
end

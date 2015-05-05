require "rails_helper"

RSpec.describe CacheKeys::Custom::Administrators do
  context "index" do
    it "uses CacheKeys::DecoratedActiveRecord" do
      expect_any_instance_of(CacheKeys::DecoratedActiveRecord).to receive(:generate)
      subject.index(decorated_administrators: nil)
    end
  end
end

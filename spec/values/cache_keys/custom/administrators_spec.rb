require "rails_helper"

RSpec.describe CacheKeys::Custom::Administrators do
  context "index" do
    let(:decorated_administrators) { instance_double(Draper::Decorator) }

    it "uses CacheKeys::DecoratedActiveRecord" do
      expect_any_instance_of(CacheKeys::DecoratedActiveRecord).to receive(:generate)
      subject.index(decorated_administrators: nil)
    end

    it "uses the correct data" do
      expect_any_instance_of(CacheKeys::DecoratedActiveRecord).to receive(:generate).with(record: decorated_administrators)
      subject.index(decorated_administrators: decorated_administrators)
    end
  end

  context "user_search" do
    let(:users) { [{ id: 1, label: "one", value: "one" }, { id: 2, label: "two", value: "two" }] }

    it "uses CacheKeys::ActiveRecord" do
      expect_any_instance_of(CacheKeys::ActiveRecord).to receive(:generate)
      subject.user_search(users: users)
    end

    it "uses the correct data" do
      expect_any_instance_of(CacheKeys::ActiveRecord).to receive(:generate).with(record: users)
      subject.user_search(users: users)
    end
  end
end

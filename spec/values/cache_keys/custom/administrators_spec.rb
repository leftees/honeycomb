require "rails_helper"

RSpec.describe CacheKeys::Custom::Administrators do
  context "index" do
    let(:administrators) { instance_double(User) }

    it "uses CacheKeys::DecoratedActiveRecord" do
      expect_any_instance_of(CacheKeys::ActiveRecord).to receive(:generate)
      subject.index(users: administrators)
    end

    it "uses the correct data" do
      expect_any_instance_of(CacheKeys::ActiveRecord).to receive(:generate).with(record: administrators)
      subject.index(users: administrators)
    end
  end

  context "user_search" do
    let(:formatted_users) { [{ id: 1, label: "one", value: "one" }, { id: 2, label: "two", value: "two" }] }

    it "uses CacheKeys::ActiveRecord" do
      expect_any_instance_of(CacheKeys::ActiveRecord).to receive(:generate)
      subject.user_search(formatted_users: formatted_users)
    end

    it "uses the correct data" do
      expect_any_instance_of(CacheKeys::ActiveRecord).to receive(:generate).with(record: formatted_users)
      subject.user_search(formatted_users: formatted_users)
    end
  end
end

require "rails_helper"

RSpec.describe CacheKeys::ActiveRecord do
  it "uses ActiveSupport to generate the key" do
    object = nil
    expect(ActiveSupport::Cache).to receive(:expand_cache_key).with(object)
    subject.generate(record: object)
  end
end

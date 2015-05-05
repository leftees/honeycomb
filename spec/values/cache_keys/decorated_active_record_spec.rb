require "rails_helper"

RSpec.describe CacheKeys::DecoratedActiveRecord do
  let(:decoratedObject)  { instance_double(Draper::Decorator, object: 1) }

  it "uses ActiveSupport to generate the key" do
    expect(ActiveSupport::Cache).to receive(:expand_cache_key)
    subject.generate(record: decoratedObject)
  end

  it "uses the decorated object, not the decorator, to generate the key" do
    expect(ActiveSupport::Cache).to receive(:expand_cache_key).with(decoratedObject.object)
    subject.generate(record: decoratedObject)
  end
end

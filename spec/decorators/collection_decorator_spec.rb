require "rails_helper"

RSpec.describe CollectionDecorator do
  let(:collection) { instance_double(Collection, id: 2, title: "title", items: Item.all) }

  subject { described_class.new(collection) }

  it "has an item_count" do
    expect(subject.item_count).to eq(0)
  end
end

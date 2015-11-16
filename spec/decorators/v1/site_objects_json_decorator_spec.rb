require "rails_helper"

RSpec.describe V1::SiteObjectsJSONDecorator do
  let(:showcase) { instance_double(Showcase, id: 0, collection_id: 1, class: double(Object, name: "Showcase")) }
  let(:page) { instance_double(Page, id: 0, collection_id: 1, class: double(Object, name: "Page")) }
  let(:item) { instance_double(Item, id: 0, collection_id: 1, class: double(Object, name: "Item")) }
  let(:user) { instance_double(User, id: 0, class: double(Object, name: "User")) }

  it "calls the correct decorator for a Showcase" do
    expect(V1::ShowcaseJSONDecorator).to receive(:display)
    described_class.display(showcase, nil)
  end

  it "calls the correct decorator for a Page"

  it "calls the correct decorator for an Item" do
    expect(V1::ItemJSONDecorator).to receive(:display)
    described_class.display(item, nil)
  end

  it "raises an exception for other types" do
    expect { described_class.display(user, nil) }.to raise_error
  end
end

require 'rails_helper'

RSpec.describe ItemPublishEmbedPanel do
  subject { described_class.new(item) }
  let(:item) { double(Item, published: true )}

  describe "display" do
    it "renders a react component" do
      expect(subject.h).to receive(:react_component).with( "ItemPublishEmbedPanel", {:publish_panel_title=>"Publish", :publish_panel_help=>"Choose if this item can be viewed.", :publish_panel_field_name=>"Published", :embed_panel_title=>"Embed", :embed_panel_help=>"Copy and paste this code into the website where you want to embed this item.", :published=>true} )
      subject.display
    end
  end

  describe "class#display" do
    it "calls the display method" do
      expect_any_instance_of(described_class).to receive(:display)
      described_class.display(item)
    end
  end
end


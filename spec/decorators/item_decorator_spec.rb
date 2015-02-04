require 'rails_helper'

RSpec.describe ItemDecorator do
  let(:item) { instance_double(Item, title: "title", description: "description", updated_at: "2014-11-06 11:45:52 -0500", id: 1, collection_id: collection.id, collection: collection, tiled_image: tiled_image, image: 'image.jpg')}
  let(:collection) { instance_double(Collection, id: 2, title: 'title')}
  let(:tiled_image) { instance_double(TiledImage, id: 3, host: "localhost", path: "path", width: '1000', height: '1000')}

  subject { described_class.new(item) }

  [:id, :title, :description].each do |field|
    it "delegates #{field}" do
      expect(subject.send(field)).to eq(item.send(field))
    end
  end

  describe '#recent_children' do 
    it 'queries items' do
      expect(item).to receive(:children).and_return(Item)
      expect(subject.recent_children).to eq([])
    end
  end

  describe 'image_tag' do
    it 'generates an image tag' do
      expect(subject.image_tag('100')).to eq("<img alt=\"Image\" src=\"/images/image.jpg\" width=\"100\" />")
    end
  end

  context 'parent item' do
    before do
      allow(item).to receive(:parent_id).and_return(nil)
    end

    it "returns true for is_parent?" do
      expect(subject.is_parent?).to be_truthy
    end

    describe '#back_path' do
      it "is the collection items index" do
        expect(subject.back_path).to eq("/collections/#{collection.id}/items")
      end
    end
  end

  context 'child item' do
    let(:child_item) { instance_double(Item, title: "Child Item", description: "description", updated_at: "2014-11-06 11:45:52 -0500", id: 2, collection_id: collection.id, collection: collection, tiled_image: child_tiled_image, image: 'image.jpg', parent_id: 1)}
    let(:child_tiled_image) { instance_double(TiledImage, id: 4, host: "localhost", path: "path", width: '1000', height: '1000')}
    subject { described_class.new(child_item) }

    it "returns false for is_parent?" do
      expect(subject.is_parent?).to be_falsey
    end

    describe '#back_path' do
      it "is the parent show route" do
        expect(subject.back_path).to eq("/collections/#{collection.id}/items/#{child_item.parent_id}/children")
      end
    end
  end
end

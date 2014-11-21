require 'rails_helper'

RSpec.describe ItemJson do
  let(:item) { instance_double(Item, title: "title", description: "description", manuscript_url: "http://example.com/manuscript", updated_at: "2014-11-06 11:45:52 -0500", id: 1, collection: collection, tiled_image: tiled_image, parent_id: nil, child_ids: [])}
  let(:collection) { instance_double(Collection, id: 2, title: 'title')}
  let(:tiled_image) { instance_double(TiledImage, id: 3, host: "localhost", path: "path", width: '1000', height: '1000')}

  let(:options) { {} }
  subject { described_class.new(item).to_hash(options) }

  context "no options" do
    [:title, :description, :updated_at, :id, :manuscript_url].each do | field |
      it "includes the field, #{field}, from item" do
        expect(item).to receive(field).and_return(field)
        subject
      end
    end

    [:id, :title].each do | field |
      it "does not include the field, #{field}, from collection " do
        expect(collection).to_not receive(field)
        subject
      end
    end

    [:id, :host, :path, :width, :height].each do | field |
      it "does not include the field, #{field}, from collection " do
        expect(tiled_image).to_not receive(field)
        subject
      end
    end

    it "includes the parent id in the links" do
      expect(item).to receive(:parent_id).and_return(1)
      expect(subject[:links][:parent]).to eq(1)
    end

    it "includes the child_ids in the links" do
      expect(item).to receive(:child_ids).and_return([2,3])
      expect(subject[:links][:children]).to eq([2,3])
    end
  end


  context "includes collection" do
    let(:options) { { include: 'collection' } }

    [:title, :description, :updated_at, :id].each do | field |
      it "includes the field, #{field}, from item" do
        expect(item).to receive(field).and_return(field)
        subject
      end
    end

    [:id, :title].each do | field |
      it "does not include the field, #{field}, from collection " do
        expect(collection).to receive(field)
        subject
      end
    end

    [:id, :host, :path, :width, :height].each do | field |
      it "does not include the field, #{field}, from tiled_image " do
        expect(tiled_image).to_not receive(field)
        subject
      end
    end
  end

  context "includes tiled_image" do
    let(:options) { { include: 'tiled_image' } }

    [:title, :description, :updated_at, :id].each do | field |
      it "includes the field, #{field}, from item" do
        expect(item).to receive(field).and_return(field)
        subject
      end
    end

    [:id, :title].each do | field |
      it "does not include the field, #{field}, from collection " do
        expect(collection).to_not receive(field)
        subject
      end
    end

    [:id, :path, :host, :width, :height].each do | field |
      it "does not include the field, #{field}, from tiled_image " do
        expect(tiled_image).to receive(field)
        subject
      end
    end
  end


  context "includes both" do
    let(:options) { { include: 'tiled_image, collection' } }

    [:title, :description, :updated_at, :id].each do | field |
      it "includes the field, #{field}, from item" do
        expect(item).to receive(field).and_return(field)
        subject
      end
    end

    [:id, :title].each do | field |
      it "does not include the field, #{field}, from collection " do
        expect(collection).to receive(field)
        subject
      end
    end

    [:id, :path, :host, :width, :height].each do | field |
      it "does not include the field, #{field}, from tiled_image " do
        expect(tiled_image).to receive(field)
        subject
      end
    end

  end

end
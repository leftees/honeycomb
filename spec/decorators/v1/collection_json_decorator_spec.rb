require 'rails_helper'

RSpec.describe V1::CollectionJSONDecorator do
  subject { V1::CollectionJSONDecorator.new(collection) }

  honeypot_image_double = nil
  exhibit_double = nil
  collection_double = nil
  before(:each) do
    honeypot_image_double = double(HoneypotImage,
                                   json_response: 'json_response')
    exhibit_double = double(Exhibit,
                            description: nil,
                            honeypot_image: honeypot_image)
    collection_double = double(Collection,
                               id: 1,
                               description: nil,
                               unique_id: 'adsf',
                               title: 'title title',
                               items: [],
                               showcases: [],
                               exhibit: exhibit)
  end
  let(:honeypot_image) { honeypot_image_double }
  let(:exhibit) { exhibit_double }
  let(:collection) { collection_double }
  let(:json) { double }

  describe 'generric fields' do
    [:id,
     :title,
     :description,
     :unique_id,
     :image,
     :updated_at].each do | field |
      it "responds to #{field}" do
        expect(subject).to respond_to(field)
      end
    end
  end

  describe '#description' do
    it 'converts null to empty string' do
      expect(subject.description).to eq('')
    end
  end

  describe '#site_intro' do
    it 'converts null to empty string' do
      expect(subject.site_intro).to eq('')
    end

    it 'gets the value from the exhibit' do
      expect(exhibit).to receive(:description).and_return('intro')
      expect(subject.site_intro).to eq('intro')
    end
  end

  describe '#at_id' do
    it 'returns the path to the id' do
      expect(subject.at_id).to eq('http://test.host/v1/collections/adsf')
    end
  end

  describe '#items_url' do
    it 'returns the path to the items' do
      expect(subject.items_url).to eq('http://test.host/v1/collections/adsf/items')
    end
  end

  describe '#slug' do
    it 'calls the slug generator' do
      expect(CreateURLSlug).to receive(:call)
        .with(collection.title).and_return('slug')
      expect(subject.slug).to eq('slug')
    end
  end

  describe '#items' do
    it 'queries for all the published items' do
      expect_any_instance_of(ItemQuery).to receive(:only_top_level)
        .and_return(['items'])
      expect(subject.items).to eq(['items'])
    end
  end

  describe '#showcases' do
    it 'queries for all the published showcases' do
      expect_any_instance_of(ShowcaseQuery).to receive(:published)
        .and_return(['showcases'])
      expect(subject.showcases).to eq(['showcases'])
    end
  end

  describe '#image' do
    it 'gets the honeypot_image json_response' do
      expect(honeypot_image).to receive(:json_response)
        .and_return('json_response')
      expect(subject.image).to eq('json_response')
    end

    it 'gets the honeypot_image from the exhibit' do
      expect(exhibit).to receive(:honeypot_image).and_return(honeypot_image)
      subject.image
    end
  end

  describe '#display' do
    it 'calls the partial for the display' do
      expect(json).to receive(:partial!)
        .with('/v1/collections/collection', collection_object: collection)
      subject.display(json)
    end
  end
end

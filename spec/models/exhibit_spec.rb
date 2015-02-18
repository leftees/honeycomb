require 'rails_helper'

RSpec.describe Exhibit do

  [:title, :description, :showcases, :collection_id].each do |field|
    it "has the field #{field}" do
      expect(subject).to respond_to(field)
      expect(subject).to respond_to("#{field}=")
    end
  end

  [:title].each do | field |
    it "requires the field, #{field}" do
      expect(subject).to have(1).error_on(field)
    end
  end

  describe '#items_json_url' do
    it 'is a url to the honeycomb server' do
      subject.collection_id = 100
      expect(subject.items_json_url).to eq("/api/collections/100/items.json?include=image")
    end
  end

  describe '#item_json_url' do
    it 'is a url to the honeycomb server' do
      subject.collection_id = 100
      expect(subject.item_json_url(5)).to eq("/api/collections/100/items/5.json?include=image")
    end
  end

end

require 'rails_helper'

RSpec.describe Showcase do

  [:title, :description, :unique_id, :image, :exhibit, :sections, :published, :collection].each do |field|
    it "has the field #{field}" do
      expect(subject).to respond_to(field)
      expect(subject).to respond_to("#{field}=")
    end
  end

  [:exhibit, :title].each do | field |
    it "requires the field, #{field}" do
      expect(subject).to have(1).error_on(field)
    end
  end

end

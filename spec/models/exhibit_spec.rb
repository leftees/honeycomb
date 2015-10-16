require "rails_helper"

RSpec.describe Exhibit do
  [:name, :description, :short_description, :showcases, :hide_title_on_home_page, :collection_id, :about, :updated_at, :created_at, :copyright].each do |field|
    it "has the field #{field}" do
      expect(subject).to respond_to(field)
      expect(subject).to respond_to("#{field}=")
    end
  end
end

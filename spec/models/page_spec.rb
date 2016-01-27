require "rails_helper"

RSpec.describe Page do
  [:name, :content, :collection, :image, :unique_id, :updated_at, :created_at, :items].each do |field|
    it "has the field #{field}" do
      expect(subject).to respond_to(field)
      expect(subject).to respond_to("#{field}=")
    end
  end

  [:collection].each do |field|
    it "requires the field, #{field}" do
      expect(subject).to have(1).error_on(field)
    end
  end

  it "has a papertrail" do
    expect(subject).to respond_to(:paper_trail_enabled_for_model?)
    expect(subject.paper_trail_enabled_for_model?).to be(true)
  end

  it "uses name for the slug" do
    subject.name = "Slug"
    expect(subject.slug).to eq(subject.name)
  end
end

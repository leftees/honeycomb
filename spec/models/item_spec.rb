require "rails_helper"

RSpec.describe Item do
  let(:image_with_spaces) { File.open(Rails.root.join("spec/fixtures", "test copy.jpg"), "r") }

  [
    :name,
    :description,
    :transcription,
    :collection,
    :honeypot_image,
    :published,
    :unique_id,
    :creator,
    :publisher,
    :alternate_name,
    :rights,
    :original_language,
    :date_created,
    :date_modified,
    :date_published,
  ].each do |field|
    it "has field, #{field}" do
      expect(subject).to respond_to(field)
      expect(subject).to respond_to("#{field}=")
    end
  end

  it "requires the name field " do
    expect(subject).to have(1).error_on(:name)
  end

  it "requires the collection field" do
    expect(subject).to have(1).error_on(:collection)
  end

  describe "#manuscript_url" do
    it "is not required" do
      expect(subject).to have(0).errors_on(:manuscript_url)
    end

    it "is valid with a url" do
      subject.manuscript_url = "http://example.com/manuscript"
      expect(subject).to have(0).errors_on(:manuscript_url)
    end

    it "is invalid with a non url value" do
      subject.manuscript_url = "manuscript"
      expect(subject).to have(1).error_on(:manuscript_url)
    end
  end

  describe "date metadata" do
    it "validates date created" do
      subject.date_created = "+-01-13"
      expect(subject).to have(1).error_on(:date_created)
    end

    it "validates date modified" do
      subject.date_modified = "+-01-13"
      expect(subject).to have(1).error_on(:date_modified)
    end

    it "validates date published" do
      subject.date_published = "+-01-13"
      expect(subject).to have(1).error_on(:date_published)
    end
  end

  it "has versioning " do
    expect(subject).to respond_to(:versions)
  end

  it "keeps spaces in the original filename" do
    subject.image = image_with_spaces
    expect(subject.image.original_filename).to eq("test copy.jpg")
  end

  it "has a parent" do
    expect(subject).to respond_to(:parent)
    expect(subject.parent).to be_nil
  end

  it "has children" do
    expect(subject).to respond_to(:children)
    expect(subject.children).to eq([])
  end

  it "has sections" do
    expect(subject).to respond_to(:sections)
    expect(subject.sections).to eq([])
  end

  it "has showcases" do
    expect(subject).to respond_to(:showcases)
    expect(subject.showcases).to eq([])
  end

  describe "#has honeypot image interface" do
    it "responds to image" do
      expect(subject).to respond_to(:image)
    end

    it "responds to honeypot_image" do
      expect(subject).to respond_to(:honeypot_image)
    end

    it "responds to collection" do
      expect(subject).to respond_to(:collection)
    end
  end
end

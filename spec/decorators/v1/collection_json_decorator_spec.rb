require "rails_helper"

RSpec.describe V1::CollectionJSONDecorator do
  subject { V1::CollectionJSONDecorator.new(collection) }

  let(:collection) { double(Collection) }

  describe "generic fields" do
    [:id,
     :unique_id,
     :about,
     :updated_at].each do |field|
      it "responds to #{field}" do
        expect(subject).to respond_to(field)
      end
    end
  end

  describe "#title" do
    it "concatinates title_line_1 and title_line_2 if there is a title_line_2" do
      expect(subject).to receive(:title_line_1).and_return("title line 1")
      expect(subject).to receive(:title_line_2).twice.and_return("title line 2")

      expect(subject.title).to eq("title line 1 title line 2")
    end

    it "does not concatintate title_line_2 if there is no title_line_2" do
      expect(subject).to receive(:title_line_1).and_return("title line 1")
      expect(subject).to receive(:title_line_2).and_return(nil)

      expect(subject.title).to eq("title line 1")
    end
  end

  describe "#title_line_1" do
    it "maps to title" do
      expect(collection).to receive(:title).and_return("super-title")
      expect(subject.title_line_1).to eq("super-title")
    end

    it "returns empty string if title is nil " do
      allow(collection).to receive(:title).and_return(nil)
      expect(subject.title_line_1).to eq("")
    end
  end

  describe "#title_line_2" do
    it "maps to subtitle" do
      expect(collection).to receive(:subtitle).and_return("super-title")
      expect(subject.title_line_2).to eq("super-title")
    end

    it "returns empty string if subtitle is nil " do
      expect(collection).to receive(:subtitle).and_return(nil)
      expect(subject.title_line_2).to eq("")
    end
  end

  describe "#description" do
    let(:collection) { double(Collection, description: nil) }

    it "converts null to empty string" do
      expect(subject.description).to eq("")
    end

    it "delegates to collection" do
      expect(collection).to receive(:description).and_return("desc")
      expect(subject.description).to eq("desc")
    end
  end

  describe "#about" do
    let(:exhibit) { double(Exhibit, about: nil) }
    let(:collection) { double(Collection, exhibit: exhibit) }

    it "converts null to empty string" do
      expect(subject.about).to eq("")
    end

    it "gets the value from the exhibit" do
      expect(exhibit).to receive(:about).and_return("about")
      expect(subject.about).to eq("about")
    end
  end

  describe "#copyright" do
    let(:exhibit) { double(Exhibit) }
    let(:collection) { double(Collection, exhibit: exhibit) }
    let(:default) { "<p><a href=\"http://www.nd.edu/copyright/\">Copyright</a> " +
                    Date.today.year.to_s +
                    " <a href=\"http://www.nd.edu\">University of Notre Dame</a></p>" }

    it "converts null to default string" do
      expect(exhibit).to receive(:copyright).and_return(nil)
      expect(subject.copyright).to eq(default)
    end

    it "converts empty string to default string" do
      expect(exhibit).to receive(:copyright).and_return("")
      expect(subject.copyright).to eq(default)
    end

    it "gets the value from the exhibit" do
      expect(exhibit).to receive(:copyright).and_return("copyright")
      expect(subject.copyright).to eq("copyright")
    end
  end

  describe "#site_intro" do
    let(:exhibit) { double(Exhibit, description: nil) }
    let(:collection) { double(Collection, exhibit: exhibit) }

    it "converts null to empty string" do
      expect(subject.site_intro).to eq("")
    end

    it "gets the value from the exhibit" do
      expect(exhibit).to receive(:description).and_return("intro")
      expect(subject.site_intro).to eq("intro")
    end
  end

  describe "#short_intro" do
    let(:exhibit) { double(Exhibit, short_description: nil) }
    let(:collection) { double(Collection, exhibit: exhibit) }

    it "converts null to empty string" do
      expect(subject.short_intro).to eq("")
    end

    it "gets the value from the exhibit" do
      expect(exhibit).to receive(:short_description).and_return("intro")
      expect(subject.short_intro).to eq("intro")
    end
  end

  describe "#at_id" do
    let(:collection) { double(Collection, unique_id: "adsf") }

    it "returns the path to the id" do
      expect(subject.at_id).to eq("http://test.host/v1/collections/adsf")
    end
  end

  describe "#items_url" do
    let(:collection) { double(Collection, unique_id: "adsf") }

    it "returns the path to the items" do
      expect(subject.items_url).to eq("http://test.host/v1/collections/adsf/items")
    end
  end

  describe "#slug" do
    let(:collection) { double(Collection, title: "title") }

    it "calls the slug generator" do
      expect(CreateURLSlug).to receive(:call).with(collection.title).and_return("slug")

      expect(subject.slug).to eq("slug")
    end
  end

  describe "#items" do
    let(:collection) { double(Collection, items: []) }

    it "queries for all the published items" do
      expect_any_instance_of(ItemQuery).to receive(:only_top_level).and_return(["items"])

      expect(subject.items).to eq(["items"])
    end
  end

  describe "#showcases" do
    let(:collection) { double(Collection, showcases: []) }

    it "queries for all the published showcases" do
      expect_any_instance_of(ShowcaseQuery).to receive(:public_api_list).and_return(["showcases"])

      expect(subject.showcases).to eq(["showcases"])
    end
  end

  describe "#image" do
    let(:exhibit) { double(Exhibit, honeypot_image: honeypot_image) }
    let(:collection) { double(Collection, exhibit: exhibit) }
    let(:honeypot_image) { double(HoneypotImage, json_response: "json_response") }

    it "gets the honeypot_image json_response" do
      expect(honeypot_image).to receive(:json_response).and_return("json_response")
      expect(subject.image).to eq("json_response")
    end

    it "gets the honeypot_image from the exhibit" do
      expect(exhibit).to receive(:honeypot_image).and_return(honeypot_image)
      subject.image
    end
  end

  describe "#display" do
    let(:json) { double }

    it "calls the partial for the display" do
      expect(json).to receive(:partial!).with("/v1/collections/collection", collection_object: collection)

      subject.display(json)
    end
  end
end

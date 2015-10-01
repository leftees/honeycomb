require "rails_helper"

RSpec.describe ExhibitsSideNav do
  let(:exhibit) { double(Exhibit, id: 1) }

  describe "#site_intro_link" do
    let(:context) { double("context", edit_exhibit_path: "path", link_to: "link") }
    let(:presenter) { described_class.new(exhibit: exhibit, form: nil) }

    before(:each) do
      allow(presenter).to receive(:h).and_return(context)
    end

    it "returns a link to the site_introduction_form" do
      expect(presenter.site_intro_link).to eq("link")
    end

    it "calls the correct path method" do
      expect(context).to receive(:edit_exhibit_path).with(exhibit)
      presenter.site_intro_link
    end
  end

  describe "#exhibit_introduction_link" do
    let(:context) { double("context", edit_exhibit_form_exhibit_path: "path", link_to: "link") }
    let(:presenter) { described_class.new(exhibit: exhibit, form: nil) }

    before(:each) do
      allow(presenter).to receive(:h).and_return(context)
    end

    it "returns a link to the exhibit_introduction_form" do
      expect(presenter.exhibit_introduction_link).to eq("link")
    end

    it "calls the correct path method" do
      expect(context).to receive(:edit_exhibit_form_exhibit_path).with(exhibit, form: "exhibit_introduction")
      presenter.exhibit_introduction_link
    end
  end

  describe "#about_text_link" do
    let(:context) { double("context", edit_exhibit_form_exhibit_path: "path", link_to: "link") }
    let(:presenter) { described_class.new(exhibit: exhibit, form: nil) }

    before(:each) do
      allow(presenter).to receive(:h).and_return(context)
    end

    it "returns a link to the about_text_form" do
      expect(presenter.about_text_link).to eq("link")
    end

    it "calls the correct path method" do
      expect(context).to receive(:edit_exhibit_form_exhibit_path).with(exhibit, form: "about_text")
      presenter.about_text_link
    end
  end

  describe "#copyright_link" do
    let(:context) { double("context", edit_exhibit_form_exhibit_path: "path", link_to: "link") }
    let(:presenter) { described_class.new(exhibit: exhibit, form: nil) }

    before(:each) do
      allow(presenter).to receive(:h).and_return(context)
    end

    it "returns a link to the copyright_link" do
      expect(presenter.copyright_link).to eq("link")
    end

    it "calls the correct path method" do
      expect(context).to receive(:edit_exhibit_form_exhibit_path).with(exhibit, form: "copyright_text")
      presenter.copyright_link
    end
  end

  describe "#search_and_browse_link" do
    let(:context) { double("context", edit_exhibit_form_exhibit_path: "path", link_to: "link") }
    let(:presenter) { described_class.new(exhibit: exhibit, form: nil) }

    before(:each) do
      allow(presenter).to receive(:h).and_return(context)
    end

    it "returns a link to the copyright_link" do
      expect(presenter.search_and_browse_link).to eq("link")
    end

    it "calls the correct path method" do
      expect(context).to receive(:edit_exhibit_form_exhibit_path).with(exhibit, form: "search_and_browse")
      presenter.search_and_browse_link
    end
  end

  describe "#active_tab_class" do
    let(:context) { double("context") }
    let(:presenter) { described_class.new(exhibit: exhibit, form: "form") }

    before(:each) do
      allow(presenter).to receive(:h).and_return(context)
    end

    it "returns active when the tab == the form " do
      expect(presenter.active_tab_class(tab: "form")).to eq("active")
    end

    it "returns empty string when the tab != form " do
      expect(presenter.active_tab_class(tab: "not_the_form")).to eq("")
    end

    it "returns active if the form is nil and the tab == edit " do
      presenter = described_class.new(exhibit: exhibit, form: nil)
      expect(presenter.active_tab_class(tab: "edit")).to eq("active")
    end
  end
end

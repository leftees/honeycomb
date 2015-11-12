require "rails_helper"

describe SavePage do
  subject { described_class.call(page, params) }

  let(:page) { instance_double(Page, id: "1", "attributes=" => true, save: true, collection: collection) }
  let(:collection) { instance_double(Collection, id: 1) }
  let(:params) { "params" }

  before(:each) do
    allow(CreateUniqueId).to receive(:call).and_return(true)
  end

  context "successful save" do
    it "sets the attributes" do
      expect(page).to receive("attributes=").with(params)
      subject
    end

    it "returns the section when it is successful" do
      expect(subject).to be(page)
    end

    it "calls save" do
      expect(page).to receive(:save).and_return(true)
      subject
    end
  end

  context "unsuccessful save" do
    before(:each) do
      allow(page).to receive(:save).and_return(false)
    end

    it "returns the false when it is unsuccessful" do
      expect(subject).to be(false)
    end

    it "calls save" do
      expect(page).to receive(:save).and_return(false)
      subject
    end
  end

  describe "unique_id" do
    it "uses the class to generate the id" do
      expect(CreateUniqueId).to receive(:call).with(page)
      subject
    end
  end
end

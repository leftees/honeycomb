require 'rails_helper'

describe SaveSection do
  subject { described_class.call(section, params) }

  let(:section) { double(Section, unique_id: 'adad', "unique_id=" => true, "attributes=" => true, save: true, "order=" => true, order: 1, "order=" => true, showcase: showcase) }
  let(:params) { { title: 'title', item_id: 1, order: 1, image: 'image', order: 1 } }
  let(:showcase) { double(Showcase, id: 1, sections: double(order: true) )}

  before(:each) do
    allow(ReorderSections).to receive(:call).and_return(true)
  end

  context "successful save" do
    before(:each) do
      expect(section).to receive(:save).and_return(true)
    end

    it "checks that the sections are ordered correctly" do
      expect(ReorderSections).to receive(:call).and_return(true)
      subject
    end

    it "sets the attributes" do
      expect(section).to receive("attributes=").with(params)
      subject
    end

    it "returns the section when it is successful" do
      expect(subject).to be(section)
    end
  end

  context "unsuccessful save" do
    before(:each) do
      expect(section).to receive(:save).and_return(false)
    end

    it "returns the false when it is unsuccessful" do

      expect(subject).to be(false)
    end
  end

  describe "unique_id" do
    it "sets a unique_id when it is saved and one does not exist" do
      expect(section).to receive(:unique_id=)
      subject
    end

    it "does not set unique_id when it is saved and one exists" do
      expect(section).to_not receive(:unique_id=)
      subject
    end

    it "uses the class to generate the id" do
      allow(section).to receive(:unique_id).and_return(nil)
      expect(CreateUniqueId).to receive(:call).with(section)
      subject
    end
  end
end

require 'rails_helper'

describe SaveSection do
  subject { described_class.call(section, params) }

  let(:section) { double(Section, "attributes=" => true, save: true, "order=" => true, order: 1, "order=" => true, showcase: showcase) }
  let(:params) { { title: 'title', item_id: 1, order: 1, image: 'image', order: 1 } }
  let(:showcase) { double(Showcase, id: 1, sections: double(order: true) )}


  context "successful save" do
    before(:each) do
      expect(ReorderSections).to receive(:call).and_return(true)
      expect(section).to receive(:save).and_return(true)
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

end

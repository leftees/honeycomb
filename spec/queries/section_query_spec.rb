require 'rails_helper'

RSpec.describe SectionQuery do

  describe "#all_for_showcase" do
    let(:sections) { double( order: true )}
    let(:showcase) { double(Showcase, sections: sections) }

    it "gets all the sections for a showcase" do
      expect(showcase).to receive(:sections).and_return(sections)
      subject.all_in_showcase(showcase)
    end


    it "orders the sections by the order field" do
      expect(sections).to receive(:order).with(:order)
      subject.all_in_showcase(showcase)
    end


  end
end

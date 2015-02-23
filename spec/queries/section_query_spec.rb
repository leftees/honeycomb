require 'rails_helper'

RSpec.describe SectionQuery do
  subject { described_class.new(relation)}

  let(:sections) { double( order: true )}
  let(:showcase) { double(Showcase, sections: relation) }
  let(:relation) { Section.all }

  describe "#all_for_showcase" do

    it "orders all the showases" do
      expect(relation).to receive(:order).with(:order).and_return(relation)
      subject.all_in_showcase
    end

  end


  describe "find" do

    it "finds the collection" do
      expect(relation).to receive(:find).with(1)
      subject.find(1)
    end
  end


  describe "build" do

    it "builds a collection off of the relation" do
      expect(relation).to receive(:build)
      subject.build
    end
  end
end

require "rails_helper"

describe ShowcaseList do
  subject { described_class.new(showcase) }

  let(:sections) { %w(section1 section2) }
  let(:showcase) { double(Showcase, exhibit: exhibit, id: 1, sections: sections) }
  let(:exhibit) { double(Exhibit, id: 1) }

  describe "sections" do
    before(:each) do
      allow_any_instance_of(SectionQuery).to receive(:ordered).and_return(sections)
    end

    it "Uses the section query" do
      expect_any_instance_of(SectionQuery).to receive(:ordered)
      expect(subject.sections).to be(sections)
    end

    it "uses the sections in the showcase as a base" do
      expect(showcase).to receive(:sections).and_return(sections)
      subject.sections
    end
  end

  it "returns the showcase" do
    expect(subject.showcase).to be(showcase)
  end

  it "returns the exhibit" do
    expect(subject.exhibit).to be(exhibit)
  end
end

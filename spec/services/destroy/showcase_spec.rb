require "rails_helper"

describe Destroy::Showcase do
  let(:section) { instance_double(Section, destroy!: true) }
  let(:showcase) { instance_double(Showcase, sections: [section, section], destroy!: true) }
  let(:destroy_section) { instance_double(Destroy::Section, cascade!: nil) }
  let(:subject) { Destroy::Showcase.new(destroy_section: destroy_section) }

  describe "#destroy" do
    it "destroys the Showcase" do
      expect(showcase).to receive(:destroy!)
      subject.destroy!(showcase: showcase)
    end
  end

  describe "#cascade" do
    it "calls DestroySection on all associated sections" do
      expect(destroy_section).to receive(:cascade!).with(section: section).twice
      subject.cascade!(showcase: showcase)
    end

    it "destroys the Section" do
      expect(showcase).to receive(:destroy!)
      subject.cascade!(showcase: showcase)
    end
  end

  context "cascade transaction" do
    let(:destroy_section) { Destroy::Section.new }
    let(:subject) { Destroy::Showcase.new(destroy_section: destroy_section) }
    let(:showcase) { FactoryGirl.create(:showcase) }
    let(:exhibit) { FactoryGirl.create(:exhibit) }
    let(:collection) { FactoryGirl.create(:collection) }
    let(:sections) { [FactoryGirl.create(:section, id: 1, showcase_id: showcase.id), FactoryGirl.create(:section, id: 2, showcase_id: showcase.id)] }

    before(:each) do
      collection
      exhibit
      sections
    end

    # Ensures all data that was created still exists
    # in the database
    def data_still_exists!
      sections.each do |section|
        expect { section.reload }.not_to raise_error
      end
      expect { showcase.reload }.not_to raise_error
    end

    it "rolls back if an error occurs with Destroy::Section" do
      # Throw error on second object to allow first one to get deleted
      allow(showcase).to receive(:sections).and_return(sections)
      allow(sections[1]).to receive(:destroy!).and_raise("error")
      expect { subject.cascade!(showcase: showcase) }.to raise_error("error")
      data_still_exists!
    end

    it "rolls back if an error occurs with Showcase.destroy!" do
      allow(showcase).to receive(:destroy!).and_raise("error")
      expect { subject.cascade!(showcase: showcase) }.to raise_error("error")
      data_still_exists!
    end
  end
end

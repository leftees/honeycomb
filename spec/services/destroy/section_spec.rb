require "rails_helper"

describe Destroy::Section do
  let(:section) { instance_double(Section) }

  describe "#destroy" do
    it "destroys the Section" do
      expect(section).to receive(:destroy!)
      subject.destroy!(section: section)
    end
  end

  describe "#cascade" do
    it "destroys the Section" do
      expect(section).to receive(:destroy!)
      subject.cascade!(section: section)
    end
  end

  context "cascade transaction" do
    let(:collection) { FactoryGirl.create(:collection) }
    let(:showcase) { FactoryGirl.create(:showcase) }
    let(:section) { FactoryGirl.create(:section) }

    # Ensures all data that was created still exists
    # in the database
    def data_still_exists!
      expect { section.reload }.not_to raise_error
    end

    it "rolls back if an error occurs with Section.destroy!" do
      collection
      showcase
      allow(section).to receive(:destroy!).and_raise("error")
      expect { subject.cascade!(section: section) }.to raise_error("error")
      data_still_exists!
    end
  end
end

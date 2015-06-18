require "rails_helper"

describe Module::Exhibit do
  let(:showcase) { instance_double(Showcase, destroy!: true) }
  let(:exhibit) { instance_double(Exhibit, showcases: [showcase, showcase], destroy!: true) }
  let(:destroy_showcase) { instance_double(Destroy::Showcase, cascade!: nil) }
  let(:subject) { Destroy::Exhibit.new(destroy_showcase: destroy_showcase) }

  describe "#destroy" do
    it "destroys the Exhibit" do
      expect(exhibit).to receive(:destroy!)
      subject.cascade!(exhibit: exhibit)
    end
  end

  describe "#cascade" do
    it "calls DestroyShowcase on all associated showcases" do
      expect(destroy_showcase).to receive(:cascade!).with(showcase: showcase).twice
      subject.cascade!(exhibit: exhibit)
    end

    it "destroys the Exhibit" do
      expect(exhibit).to receive(:destroy!)
      subject.cascade!(exhibit: exhibit)
    end
  end

  context "cascade transaction" do
    let(:destroy_showcase) { Destroy::Showcase.new }
    let(:subject) { Destroy::Exhibit.new(destroy_showcase: destroy_showcase) }
    let(:exhibit) { FactoryGirl.create(:exhibit) }
    let(:collection) { FactoryGirl.create(:collection) }
    let(:showcases) { [FactoryGirl.create(:showcase, id: 1, exhibit_id: exhibit.id), FactoryGirl.create(:showcase, id: 2, exhibit_id: exhibit.id)] }

    before(:each) do
      collection
      showcases
    end

    # Ensures all data that was created still exists
    # in the database
    def data_still_exists!
      showcases.each do |showcase|
        expect { showcase.reload }.not_to raise_error
      end
      expect { exhibit.reload }.not_to raise_error
    end

    it "rolls back if an error occurs with Destroy::Showcase" do
      # Throw error on second object to allow first one to get deleted
      allow(exhibit).to receive(:showcases).and_return(showcases)
      allow(showcases[1]).to receive(:destroy!).and_raise("error")
      expect { subject.cascade!(exhibit: exhibit) }.to raise_error("error")
      data_still_exists!
    end

    it "rolls back if an error occurs with Exhibit.destroy!" do
      allow(exhibit).to receive(:destroy!).and_raise("error")
      expect { subject.cascade!(exhibit: exhibit) }.to raise_error("error")
      data_still_exists!
    end
  end
end

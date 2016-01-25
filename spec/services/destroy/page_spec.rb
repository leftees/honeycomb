require "rails_helper"

describe Destroy::Page do
  let(:page) { instance_double(Page, id: 1) }

  describe "#destroy" do
    it "destroys the Page" do
      expect(page).to receive(:destroy!)
      subject.destroy!(page: page)
    end
  end

  describe "#cascade" do
    it "destroys the Page" do
      expect(page).to receive(:destroy!)
      expect(DestroyPageItemAssociations).to receive(:call).and_return(1)
      subject.cascade!(page: page)
    end
  end

  context "cascade transaction" do
    let(:collection) { FactoryGirl.create(:collection) }
    let(:page) { FactoryGirl.create(:page) }

    # Ensures all data that was created still exists
    # in the database
    def data_still_exists!
      expect { page.reload }.not_to raise_error
    end

    it "rolls back if an error occurs with Page.destroy!" do
      collection
      page
      allow(page).to receive(:destroy!).and_raise("error")
      expect { subject.cascade!(page: page) }.to raise_error("error")
      data_still_exists!
    end
  end
end

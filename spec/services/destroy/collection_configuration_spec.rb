require "rails_helper"

describe Destroy::CollectionConfiguration do
  let(:collection_configuration) { instance_double(CollectionConfiguration) }

  describe "#destroy" do
    it "destroys the CollectionConfiguration" do
      expect(collection_configuration).to receive(:destroy!)
      subject.destroy!(collection_configuration: collection_configuration)
    end
  end

  describe "#cascade" do
    it "destroys the CollectionConfiguration" do
      expect(collection_configuration).to receive(:destroy!)
      subject.cascade!(collection_configuration: collection_configuration)
    end
  end

  context "cascade transaction" do
    let(:collection) { FactoryGirl.create(:collection) }
    let(:collection_configuration) { FactoryGirl.create(:collection_configuration) }

    # Ensures all data that was created still exists
    # in the database
    def data_still_exists!
      expect { collection_configuration.reload }.not_to raise_error
    end

    it "rolls back if an error occurs with CollectionConfiguration.destroy!" do
      collection
      allow(collection_configuration).to receive(:destroy!).and_raise("error")
      expect { subject.cascade!(collection_configuration: collection_configuration) }.to raise_error("error")
      data_still_exists!
    end
  end
end

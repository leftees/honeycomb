require "rails_helper"

RSpec.describe SaveCollection, type: :model do
  subject { described_class.call(collection, params) }
  let(:collection) { Collection.new }
  let(:params) { { title: 'title' } }

  it "returns when the collection save is successful" do
    expect(collection).to receive(:save).and_return(true)
    expect(subject).to be true
  end

  it "returns when the collection save is not successful" do
    expect(collection).to receive(:save).and_return(false)
    expect(subject).to be false
  end

  it "sets the attributes of the collection to be the passed in attributes " do
    expect(collection).to receive(:attributes=).with(params)
    subject
  end

  describe "unique_id" do
    it "sets a unique_id when it is saved and one does not exist" do
      expect(collection).to receive(:unique_id=)
      subject
    end

    it "does not set unique_id when it is saved and one exists" do
      collection.unique_id = '1231232'
      expect(collection).to_not receive(:unique_id=)
      subject
    end

    it "uses the class to generate the id" do
      expect(CreateUniqueId).to receive(:call).with(collection)
      subject
    end
  end
end

require "rails_helper"

RSpec.describe SaveCollection, type: :model do
  subject { described_class.call(collection, params) }
  let(:collection) { double(Collection, id: 'id', "attributes=" => true, save: true, "unique_id=" => true, unique_id: 'uid') }
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

    it "uses the class to generate the id" do
      allow(collection).to receive(:unique_id).and_return(nil)

      expect(CreateUniqueId).to receive(:call).with(collection)
      subject
    end
  end
end

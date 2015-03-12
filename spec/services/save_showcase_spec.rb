require "rails_helper"

RSpec.describe SaveShowcase, type: :model do
  subject { described_class.call(showcase, params) }
  let(:showcase) { Showcase.new }
  let(:params) { { title: 'title' } }

  it "returns when the showcase save is successful" do
    expect(showcase).to receive(:save).and_return(true)
    expect(subject).to be true
  end

  it "returns when the showcase save is not successful" do
    expect(showcase).to receive(:save).and_return(false)
    expect(subject).to be false
  end

  it "sets the attributes of the showcase to be the passed in attributes " do
    expect(showcase).to receive(:attributes=).with(params)
    subject
  end


  describe "unique_id" do
    it "sets a unique_id when it is saved and one does not exist" do
      expect(showcase).to receive(:unique_id=)
      subject
    end

    it "does not set unique_id when it is saved and one exists" do
      showcase.unique_id = '1231232'
      expect(showcase).to_not receive(:unique_id=)
      subject
    end

    it "uses the class to generate the id" do
      expect(CreateUniqueId).to receive(:call).with(showcase)
      subject
    end
  end
end

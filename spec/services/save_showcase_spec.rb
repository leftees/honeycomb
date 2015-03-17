require "rails_helper"

RSpec.describe SaveShowcase, type: :model do
  subject { described_class.call(showcase, params) }
  let(:showcase) { Showcase.new }
  let(:params) { { title: 'title' } }

  before(:each) do
    allow(CreateUniqueId).to receive(:call).and_return(true)
  end

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
    before(:each) do
      allow(showcase).to receive(:save).and_return(true)
    end

    it "uses the class to generate the id" do
      expect(CreateUniqueId).to receive(:call).with(showcase)
      subject
    end

    it "does not call create unique_id if the showcase does not save" do
      allow(showcase).to receive(:save).and_return(false)
      expect(CreateUniqueId).to_not receive(:call).with(showcase)
      subject
    end

  end
end

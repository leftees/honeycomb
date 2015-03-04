require 'rails_helper'

describe Publish do
  subject { described_class.call(object) }
  let(:object) { double(Object, "published=" => true, save: true) }

  it "sets the object to be published" do
    expect(object).to receive(:published=).with(true)
    subject
  end

  it "saves the object" do
    expect(object).to receive(:save).and_return(true)
    subject
  end

  it "returns true of the object is saved" do
    expect(subject).to be true
  end

  it "returns false if the object save fails " do
    allow(object).to receive("save").and_return(false)
    expect(subject).to be false
  end
end

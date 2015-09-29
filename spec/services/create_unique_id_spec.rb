require "rails_helper"

describe CreateUniqueId do
  subject { described_class.new(object) }
  let(:object) { double(id: 1, class: "Class", unique_id: nil, "unique_id=" => true, save: true) }

  it "generates a id" do
    expect(object).to receive(:unique_id=).with(anything)
    subject.create
  end

  it "uses the SecureRandom lib to generate the id " do
    expect(SecureRandom).to receive(:hex)
    subject.create
  end

  it "sets a unique_id when it is saved and one does not exist" do
    expect(object).to receive(:unique_id=)
    subject.create
  end

  it "returns the generated id" do
    allow(SecureRandom).to receive(:hex).and_return("unique_id")
    expect(subject.create).to eq("unique_id")
  end

  describe "existing unique_id" do
    before(:each) do
      allow(object).to receive(:unique_id).and_return("1231232")
    end

    it "does not set unique_id when it is saved and one exists" do
      expect(object).to_not receive(:unique_id=)
      subject.create
    end

    it "returns the existing id" do
      expect(subject.create).to eq("1231232")
    end
  end

  describe "initilaize" do
    it "raises an error if the object is not duck typed" do
      expect { described_class.new(Object.new) }.to raise_error
    end
  end

  describe "#call" do
    it "calls publish!" do
      expect_any_instance_of(described_class).to receive(:create)
      described_class.call(object)
    end
  end
end

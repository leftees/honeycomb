require "rails_helper"

describe "SetCollectionPreviewMode" do
  let(:collection) { instance_double(Collection, "preview_mode=" => false, save: true) }
  subject(:subject) { SetCollectionPreviewMode.new(collection, true) }

  describe "#!enable_preview" do
    it "should set the preview mode to true" do
      expect(collection).to receive(:preview_mode=).with(true)
      subject.set_preview_mode
    end

    it "should save the collection record" do
      expect(collection).to receive(:save).and_return(true)
      subject.set_preview_mode
    end

    it "should return false if the save fails" do
      allow(collection).to receive(:save).and_return(false)
      expect(subject.set_preview_mode).to be_falsey
    end
  end

  describe "#!call" do
    it "uses the set_preview_mode method" do
      expect_any_instance_of(SetCollectionPreviewMode).to receive(:set_preview_mode)
      SetCollectionPreviewMode.call(collection, true)
    end
  end
end

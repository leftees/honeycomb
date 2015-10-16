require "rails_helper"

RSpec.describe SaveExhibit, type: :model do
  subject { described_class.call(exhibit, params) }
  let(:exhibit) { Exhibit.new }
  let(:params) { { name: "name" } }
  let(:upload_image) { Rack::Test::UploadedFile.new(Rails.root.join("spec/fixtures/test.jpg"), "image/jpeg") }

  before(:each) do
    allow(exhibit).to receive(:save).and_return(true)
  end

  it "returns when the save is successful" do
    expect(exhibit).to receive(:save).and_return(true)
    expect(subject).to be true
  end

  it "returns when the save is not successful" do
    expect(exhibit).to receive(:save).and_return(false)
    expect(subject).to be false
  end

  it "sets the attributes to the new values " do
    expect(exhibit).to receive(:attributes=).with(params)
    subject
  end
end

require 'rails_helper'

describe CreateUniqueId do
  let(:object) { double(id: 1, class: "Class") }

  it "generates a id" do
    expect(described_class.call(object)).to eq("6187bbca38")
  end

  it "uses the md5 lib to generate the id " do
     expect(Digest::MD5).to receive(:hexdigest).with("#{object.id}-#{object.class}").and_return("adfadfafsdadsdasdafs")
     described_class.call(object)
  end

end

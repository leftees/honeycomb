RSpec.describe Waggle::Search::Hit do

  let(:adapter_hit) { double(name: 'name', at_id: 'at_id', type: "Item", description: "Description", date_created: "date_created", creator: "creator", thumbnail_url: "thumbnail", last_updated: "last_updated")}
  subject { described_class.new(adapter_hit) }

  [
    :name,
    :at_id,
    :type,
    :description,
    :date_created,
    :creator,
    :thumbnail_url,
    :last_updated
  ].each do | field |
    describe "##{field}" do
      it "calls the appropriate method on the adapter_hit" do
        expect(adapter_hit).to receive(field)
        subject.send(field)
      end

      it "returns the data from the adapter_hit" do
        expect(subject.send(field)).to eq(adapter_hit.send(field))
      end
    end
  end

  describe "#short_description" do
    it "calls the appropriate methods on the adapter_hit" do
      expect(adapter_hit).to receive(:creator)
      expect(adapter_hit).to receive(:date_created)
      subject.short_description
    end

    it "returns the data from the adapter_hit creator and date_created" do
      expect(subject.short_description).to eq("#{adapter_hit.creator} #{adapter_hit.date_created}")
    end
  end
end

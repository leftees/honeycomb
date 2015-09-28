require "rails_helper"

RSpec.describe MetadataDate::ConvertToIsoDate do
  describe "#convert!" do
    it "converts a date with year, month, day" do
      date = MetadataDate.new(year: "2010", month: "10", day: "10", bc: false)
      expect(described_class.new(date).convert).to eq("2010-10-10")
    end

    it "pads year, month, day" do
      date = MetadataDate.new(year: "1", month: "2", day: "3", bc: false)
      expect(described_class.new(date).convert).to eq("0001-02-03")
    end

    it "converts a date with year, month" do
      date = MetadataDate.new(year: "2010", month: "10", day: nil, bc: false)
      expect(described_class.new(date).convert).to eq("2010-10")
    end

    it "converts a date with year, month and empty strings" do
      date = MetadataDate.new(year: "2010", month: "10", day: "", bc: false)
      expect(described_class.new(date).convert).to eq("2010-10")
    end

    it "converts a date with year" do
      date = MetadataDate.new(year: "2010", day: nil, month: nil, bc: false)
      expect(described_class.new(date).convert).to eq("2010")
    end

    it "converts a date with year with empty strings" do
      date = MetadataDate.new(year: "2010", day: "", month: "", bc: false)
      expect(described_class.new(date).convert).to eq("2010")
    end

    it "adds the - for bc dates" do
      date = MetadataDate.new(year: "2010", month: "10", day: "10", bc: true)
      expect(described_class.new(date).convert).to eq("-2010-10-10")
    end

    it "returns false if the metadata_date is invalid" do
      date = MetadataDate.new({})
      expect(described_class.new(date).convert).to eq(false)
    end

    it "returns false if the metadata_date is not a valid day" do
      date = MetadataDate.new(year: "2010", month: "02", day: "30", bc: false)
      expect(described_class.new(date).convert).to eq(false)
    end
  end
end

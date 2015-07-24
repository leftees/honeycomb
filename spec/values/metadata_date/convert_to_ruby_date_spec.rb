require "rails_helper"

RSpec.describe MetadataDate::ConvertToRubyDate do
  describe "#convert!" do
    it "converts a date with year, month, day" do
      date = double(MetadataDate, year: "2010", month: "10", day: "10", valid?: true)
      expect(described_class.new(date).convert!).to eq(Date.new(2010, 10, 10))
    end

    it "converts a date with year, month" do
      date = double(MetadataDate, year: "2010", month: "10", day: nil, valid?: true)
      expect(described_class.new(date).convert!).to eq(Date.new(2010, 10))
    end

    it "converts a date with year" do
      date = double(MetadataDate, year: "2010", day: nil, month: nil, valid?: true)
      expect(described_class.new(date).convert!).to eq(Date.new(2010))
    end

    it "raises errors when there is an invalid date" do
      date = double(MetadataDate, year: "2010", month: "2", day: "30", valid?: true)
      expect { described_class.new(date).convert! }.to raise_error(ArgumentError)
    end

    it "raises an error when the year is a string" do
      date = double(MetadataDate, year: "e2010", month: "2", day: "30", valid?: true)
      expect { described_class.new(date).convert! }.to raise_error(ArgumentError)
    end

    it "raises an error when the month is a string" do
      date = double(MetadataDate, year: "2010", month: "wer", day: "30", valid?: true)
      expect { described_class.new(date).convert! }.to raise_error(ArgumentError)
    end

    it "raises an error when the day is a string" do
      date = double(MetadataDate, year: "2010", month: "2", day: "sdfg", valid?: true)
      expect { described_class.new(date).convert! }.to raise_error(ArgumentError)
    end

    it "returns false if the metadata_date is invalid?" do
      date = double(MetadataDate, valid?: false)
      expect(described_class.new(date).convert!).to eq(false)
    end
  end

  describe "#convert" do
    it "calls convert!" do
      object = described_class.new("")
      expect(object).to receive(:convert!).and_return("conveted")
      object.convert
    end

    it "catches the argument error" do
      object = described_class.new("")
      expect(object).to receive(:convert!).and_raise(ArgumentError.new(""))
      expect(object.convert).to eq(false)
    end
  end
end

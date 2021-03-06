require "rails_helper"

RSpec.describe Metadata::Fields::DateField::FormatDisplayText do
  it "returns the display text field when there is a display text" do
    date = Metadata::Fields::DateField.new(display_text: "Text to display", year: "2010")
    expect(Metadata::Fields::DateField::FormatDisplayText.format(date)).to eq("Text to display")
  end

  it "returns the year month day format when all are present" do
    date = Metadata::Fields::DateField.new(display_text: nil, bc: false, day: "5", month: "10", year: "1000")
    expect(Metadata::Fields::DateField::FormatDisplayText.format(date)).to eq("October 05, 1000")
  end

  it "returns the year month format when all are present" do
    date = Metadata::Fields::DateField.new(display_text: nil, bc: false, day: nil, month: "10", year: "1000")
    expect(Metadata::Fields::DateField::FormatDisplayText.format(date)).to eq("October, 1000")
  end

  it "returns the year format when all are present" do
    date = Metadata::Fields::DateField.new(display_text: nil, bc: false, day: nil, month: nil, year: "1000")
    expect(Metadata::Fields::DateField::FormatDisplayText.format(date)).to eq("1000")
  end

  it "adds BC when the year is BC" do
    date = Metadata::Fields::DateField.new(display_text: nil, bc: true, day: "5", month: "10", year: "1000")
    expect(Metadata::Fields::DateField::FormatDisplayText.format(date)).to match(/ BC$/)
  end

  it "when the date is BC year is displayed in the possitive" do
    date = Metadata::Fields::DateField.new(display_text: nil, bc: true, day: "5", month: "10", year: "1000")
    expect(Metadata::Fields::DateField::FormatDisplayText.format(date)).to_not include("-1000")
  end

  it "returns empty string when the metadata date is not valid?" do
    date = Metadata::Fields::DateField.new(display_text: nil)
    expect(Metadata::Fields::DateField::FormatDisplayText.format(date)).to include("")
  end
end

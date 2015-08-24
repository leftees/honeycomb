class MetadataDate
  include ActiveModel::Validations

  attr_reader :year, :month, :day, :bc, :display_text

  validates :year, numericality: { only_integer: true, allow_blank: false, greater_than: 0, less_than_or_equal_to: 9999 }
  validates :month, numericality: { only_integer: true, allow_blank: true, greater_than_or_equal_to: 1, less_than_or_equal_to: 12 }
  validates :day, numericality: { only_integer: true, allow_blank: true, greater_than_or_equal_to: 1, less_than_or_equal_to: 31 }
  validates :month, presence: true, if: :month_required?

  def self.from_hash(hash)
    new(**hash.symbolize_keys)
  end

  def initialize(year: nil, month: nil, day: nil, bc: nil, display_text: nil)
    @year = parse_value(year)
    @month = parse_value(month)
    @day = parse_value(day)
    @bc = bc
    @display_text = parse_value(display_text)
  end

  def bc?
    bc.to_s == "true"
  end

  def human_readable
    @human_readable ||= FormatDisplayText.format(self)
  end

  def iso8601
    @iso ||= ConvertToIsoDate.new(self).convert
  end

  def to_date
    @date ||= ConvertToRubyDate.new(self).convert
  end

  def to_hash
    {
      "@type" => "MetadataDate",
      value: human_readable,
      iso8601: iso8601,
      year: year,
      month: month,
      day: day,
      bc: bc,
      displayText: display_text,
    }
  end

  def to_params
    {
      year: year,
      month: month,
      day: day,
      bc: bc,
      display_text: display_text,
    }.stringify_keys
  end

  def self.parse(string)
    date_and_display = string.split(":")
    if date_and_display.length > 0
      display_text = date_and_display.length > 1 ? date_and_display[1] : nil
      date_array = date_and_display[0].split("/")
      year = date_array.length >= 1 ? date_array[0].to_i : nil
      month = date_array.length > 1 ? date_array[1].to_i : nil
      day = date_array.length > 2 ? date_array[2].to_i : nil
      bc = (year < 0)
      new(year: year.abs, month: month, day: day, bc: bc, display_text: display_text)
    end
  end

  private

  def parse_value(value)
    value ? value.to_s.strip : nil
  end

  def month_required?
    day.present?
  end
end

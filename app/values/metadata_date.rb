class MetadataDate
  include ActiveModel::Validations

  attr_reader :year, :month, :day, :bc, :display_text

  validates :year, numericality: { only_integer: true, allow_nil: false, greater_than_or_equal_to: 0, less_than_or_equal_to: 9999 }
  validates :month, numericality: { only_integer: true, allow_nil: true, greater_than_or_equal_to: 1, less_than_or_equal_to: 12 }
  validates :day, numericality: { only_integer: true, allow_nil: true, greater_than_or_equal_to: 1, less_than_or_equal_to: 31 }
  validates :month, presence: true, if: :month_required?

  def initialize(year: nil, month: nil, day: nil, bc: nil, display_text: nil)
    @year = parse_value(year)
    @month = parse_value(month)
    @day = parse_value(day)
    @bc = bc
    @display_text = parse_value(display_text)
  end

  def bc?
    bc.present?
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

  private

  def parse_value(value)
    value ? value.to_s.strip : nil
  end

  def month_required?
    day.present?
  end

  class FormatDisplayText
    attr_reader :metadata_date

    def self.format(metadata_date)
      new(metadata_date).format
    end

    def initialize(metadata_date)
      @metadata_date = metadata_date
    end

    def format
      if metadata_date.display_text.present?
        metadata_date.display_text
      else
        format_date
      end
    end

    private

    def date_format
      if metadata_date.day
        :year_month_day
      elsif metadata_date.month
        :year_month
      else
        :year_only
      end
    end

    def format_date
      if !date = metadata_date.to_date
        return ""
      end

      date = I18n.localize(date, format: date_format)
      date = add_bc_to_date(date)

      date
    end

    def add_bc_to_date(date)
      if metadata_date.bc?
        date += " BC"
      end
      date
    end
  end

  class ConvertToRubyDate
    attr_reader :metadata_date

    def initialize(metadata_date)
      @metadata_date = metadata_date
    end

    def convert!
      return false if !metadata_date.valid?

      if values.present?
        Date.new(*values)
      else
        raise "Invalid metadata date. I expect this state to be unreachable so there is an error somewhere."
      end
    end

    def convert
      convert!
    rescue ArgumentError
      false
    end

    private

    def values
      @values ||= [metadata_date.year, metadata_date.month, metadata_date.day].compact.map(&:to_i)
    end
  end

  class ConvertToIsoDate
    attr_reader :metadata_date

    def initialize(metadata_date)
      @metadata_date = metadata_date
    end

    def convert
      return false if !metadata_date.valid? || !metadata_date.to_date

      date = format_date
      format_bc(date)
    end

    private

    def format_date
      if values.present?
        values.join("-")
      else
        raise "Invalid metadata date. I expect this state to be unreachable so there is an error somewhere."
      end
    end

    def format_bc(date)
      if metadata_date.bc?
        date = "-#{date}"
      end
      date
    end

    def values
      @values ||= [metadata_date.year, metadata_date.month, metadata_date.day].compact
    end
  end
end

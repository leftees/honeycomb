class MetadataDate
  include ActiveModel::Validations

  attr_reader :date_data, :display_text, :year, :month, :day, :bc

  validates :year, numericality:{ only_integer: true, allow_nil: false, greater_than_or_equal_to: 0, less_than_or_equal_to: 9999  }
  validates :month, numericality:{ only_integer: true, allow_nil: true, greater_than_or_equal_to: 1, less_than_or_equal_to: 12 }
  validates :day, numericality:{ only_integer: true, allow_nil: true, greater_than_or_equal_to: 1, less_than_or_equal_to: 31  }

  class ParseError < Exception
  end

  def initialize(data)
    @date_data = data
  end

  def bc?
    date_data[:bc]
  end

  def human_readable
    @human_readable ||= FormatDisplayText.format(self)
  end

  def display_text
    date_data[:display_text]
  end

  def year
    @year ||= date_data[:year] ? date_data[:year].strip : nil
  end

  def month
    @month ||= date_data[:month] ? date_data[:month].strip : nil
  end

  def day
    @day ||= date_data[:day] ? date_data[:day].strip : nil
  end

  def iso8601
    @iso ||= ConvertToIsoDate.new(self).convert
  end

  def to_date
    @date ||= ConvertToRubyDate.new(self).convert
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

      if metadata_date.day
        Date.new(metadata_date.year.to_i, metadata_date.month.to_i, metadata_date.day.to_i)
      elsif metadata_date.month
        Date.new(metadata_date.year.to_i, metadata_date.month.to_i)
      elsif metadata_date.year
        Date.new(metadata_date.year.to_i)
      else
        raise "Invalid metadata date. I expect this state to be unreachable so there is an error somewhere."
      end
    end

    def convert
      convert!
    rescue ArgumentError
      false
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
      if metadata_date.day
        "#{metadata_date.year}-#{metadata_date.month}-#{metadata_date.day}"
      elsif metadata_date.month
        "#{metadata_date.year}-#{metadata_date.month}"
      elsif metadata_date.year
        "#{metadata_date.year}"
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
  end
end

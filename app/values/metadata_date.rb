class MetadataDate
  include ActiveModel::Validations

  attr_reader :date_data, :display_text, :year, :month, :day, :bc

  validates :year, numericality: { only_integer: true, allow_nil: false, greater_than_or_equal_to: 0, less_than_or_equal_to: 9999  }
  validates :month, numericality: { only_integer: true, allow_nil: true, greater_than_or_equal_to: 1, less_than_or_equal_to: 12 }
  validates :day, numericality: { only_integer: true, allow_nil: true, greater_than_or_equal_to: 1, less_than_or_equal_to: 31  }


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
    date_data[:year]
  end

  def month
    date_data[:month]
  end

  def day
    date_data[:day]
  end

  private

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
      if !date = ruby_date
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

    def ruby_date
      if metadata_date.valid?
        if metadata_date.day
          @date = Date.new(metadata_date.year.to_i, metadata_date.month.to_i, metadata_date.day.to_i)
        elsif metadata_date.month
          @date = Date.new(metadata_date.year.to_i, metadata_date.month.to_i)
        elsif metadata_date.year
          @date = Date.new(metadata_date.year.to_i)
        else
          raise ParseError.new("Unable to setup date from parsed data")
        end
      else
        false
      end
    end

  end
end

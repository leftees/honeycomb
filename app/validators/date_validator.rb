# Validator to make sure submitted date is correctly formatted
class DateValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    return if !value

    date = MetadataDate.new(value)
    if !date.valid?
      date.errors.full_messages.each do | msg |
        record.errors[attribute] << msg
      end
    end
  end
end

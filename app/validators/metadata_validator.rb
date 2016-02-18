class MetadataValidator < ActiveModel::Validator
  attr_reader :record

  def validate(record)
    @record = record
    validates_presence
  end

  private

  def validates_presence
    configuration.fields.each do |field|
      value = record.field(field.name)
      if not_present?(field, value)
        record.errors[field.name] << "is required"
      end
    end
  end

  def configuration
    @configuration ||= CollectionConfigurationQuery.new(record.item.collection).find
  end

  def not_present?(field, value)
    field.required && (value.nil? || value.empty?)
  end
end

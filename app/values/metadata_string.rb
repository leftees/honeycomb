class MetadataString
  attr_reader :value

  def initialize(value)
    @value = value
  end

  def to_hash(label)
    {
      "@type" => "string",
      label: label,
      value: value,
    }
  end
end

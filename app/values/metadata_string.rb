class MetadataString
  attr_reader :value

  def initialize(value)
    @value = value
  end

  def to_hash
    {
      "@type" => "MetadataString",
      value: value,
    }
  end
end

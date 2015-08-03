class MetadataHTML
  attr_reader :value

  def initialize(value)
    @value = value
  end

  def to_hash
    {
      "@type" => "MetadataHTML",
      value: value,
    }
  end
end

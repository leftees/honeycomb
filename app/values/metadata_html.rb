class MetadataHtml
  attr_reader :value

  def initialize(value)
    @value = value
  end

  def to_hash(label)
    {
      "@type" => "html",
      label: label,
      value: value,
    }
  end
end

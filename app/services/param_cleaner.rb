class ParamCleaner
  # Transforms all values recursively using the map below:
  # "true"  => true
  # "false" => false
  # ""      => nil
  def self.call(hash:)
    transform_values_recursively!(hash: hash) do |value|
      case value
      when "true"
        true
      when "false"
        false
      when ""
        nil
      else
        value
      end
    end
  end

  # Similar to built-in Hash.transform_values! except it will transform it recursively
  # for nested hashes
  def self.transform_values_recursively!(hash:)
    hash.each_pair do |key, value|
      if value.respond_to?(:each_pair) && value.respond_to?("[]")
        hash[key] = transform_values_recursively!(hash: value) { |v| yield(v) }
      else
        hash[key] = yield(value)
      end
    end
  end
end

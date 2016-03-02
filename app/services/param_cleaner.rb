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
    if hash.respond_to?(:each_index) && hash.respond_to?("[]")
      # Transform each item in the array
      hash = hash.each_index do |i|
        hash[i] = transform_values_recursively!(hash: hash[i]) { |v| yield(v) }
      end
    elsif hash.respond_to?(:each_pair) && hash.respond_to?("[]")
      # Transform each pair in the hash
      hash.each_pair do |key, value|
        hash[key] = transform_values_recursively!(hash: value) { |v| yield(v) }
      end
    else
      hash = yield(hash)
    end
  end
end

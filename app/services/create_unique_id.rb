require "digest/md5"

class CreateUniqueId
  attr_reader :object

  def self.call(object)
    new(object).create
  end

  def initialize(object)
    @object = object
    validate_interface!
  end

  def create
    if object.unique_id.nil?
      object.unique_id = unique_id
    else
      object.unique_id
    end
  end

  private

  def unique_id
    SecureRandom.hex(5)
  end

  def validate_interface!
    unless object.respond_to?("unique_id=") && object.respond_to?(:unique_id) && object.respond_to?(:save)
      fail "Object passed to CreateUniqueId is not valid"
    end
  end
end

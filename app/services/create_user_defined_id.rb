require "digest/md5"

class CreateUserDefinedId
  attr_reader :object

  def self.call(object)
    new(object).create
  end

  def initialize(object)
    @object = object
    validate_interface!
  end

  def create
    if object.user_defined_id.nil?
      object.user_defined_id = unique_id
    else
      object.user_defined_id
    end
  end

  private

  def unique_id
    SecureRandom.uuid
  end

  def validate_interface!
    unless object.respond_to?("user_defined_id=") && object.respond_to?(:user_defined_id) && object.respond_to?(:save)
      fail "Object passed to CreateUserDefinedId is not valid"
    end
  end
end

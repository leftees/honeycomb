require 'digest/md5'

class CreateUniqueId
  attr_reader :object

  def self.call(object)
    new(object).create
  end

  def initialize(object)
    @object = object
  end

  def create
    Digest::MD5.hexdigest("#{object.id}-#{object.class}")[0...10]
  end

end

class SaveShowcase
  attr_reader :params, :showcase

  def self.call(showcase, params)
    new(showcase, params).save
  end

  def initialize(showcase, params)
    @params = params
    @showcase = showcase
  end

  def save
    showcase.attributes = params
    showcase.save
  end

end


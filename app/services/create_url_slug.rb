class CreateURLSlug
  attr_reader :name

  def self.call(name)
    new(name).create
  end

  def initialize(name)
    if name.is_a?(Array)
      @name = name.first
    else
      @name = name
    end
  end

  def create
    if name.present?
      name.downcase.gsub(/\s+/, "-").gsub(/[^0-9a-z-]/i, "")
    else
      "name"
    end
  end
end

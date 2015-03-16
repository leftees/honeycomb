class CreateURLSlug
  attr_reader :title

  def self.call(title)
    new(title).create
  end

  def initialize(title)
    @title = title
  end

  def create
    title.downcase.gsub(/\s+/, '-').gsub(/[^0-9a-z-]/i, '')
  end
end

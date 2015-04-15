class ShowcaseList
  attr_reader :showcase
  delegate :exhibit, to: :showcase

  def initialize(showcase)
    @showcase = showcase
  end

  def sections
    SectionQuery.new(showcase.sections).ordered
  end

  def collection
    exhibit.collection
  end
end

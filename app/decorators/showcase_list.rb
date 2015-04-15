class ShowcaseList

  def initialize(showcase)
    @showcase = showcase
  end

  delegate :exhibit, to: :showcase

  attr_reader :showcase

  def sections
    SectionQuery.new(showcase.sections).ordered
  end
end

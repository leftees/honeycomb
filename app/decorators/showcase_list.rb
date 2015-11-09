class ShowcaseList
  attr_reader :showcase
  delegate :collection, to: :showcase

  def initialize(showcase)
    @showcase = showcase
  end

  def sections
    SectionQuery.new(showcase.sections).ordered
  end
end

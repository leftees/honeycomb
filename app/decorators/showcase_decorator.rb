class ShowcaseDecorator < Draper::Decorator
  delegate :id, :title, :description, to: :object

  def sections
    SectionQuery.new(object.sections).all_in_showcase
  end
end

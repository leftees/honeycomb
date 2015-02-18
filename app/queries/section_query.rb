class SectionQuery

  def all_in_showcase(showcase)
    showcase.sections.order(:order)
  end

end

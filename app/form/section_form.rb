class SectionForm
  attr_reader :section

  def self.build_from_params(controller)
    if controller.params[:id]
      section = SectionQuery.new.find(controller.params[:id])
    else
      showcase = ShowcaseQuery.new.find(controller.params[:showcase_id])
      section = SectionQuery.new(showcase.sections).build(controller.params[:section])
    end

    new(section)
  end

  def initialize(section)
    @section = section
    validate!
  end

  def form_url
    [ section.showcase.exhibit, section.showcase, section ]
  end

  def form_partial
    if section_type == 'image'
      'image_form'
    elsif section_type == 'text'
      'text_form'
    else
      raise "Implment section form for type #{section.display_type}"
    end
  end

  def title
    section.title
  end

  private

    def section_type
      @type ||= SectionType.new(section).type
    end

    def validate!
      if section.order.blank?
        raise "Section passed to section form requires an order "
      end
    end

end

class ShowcaseDecorator < Draper::Decorator
  delegate :id, :title, :description, to: :object

  def sections
    SectionQuery.new(object.sections).all_in_showcase
  end

  def honeypot_image_url
    if object.honeypot_image
      object.honeypot_image.json_response['contentUrl']
    else
      {}
    end
  end
end

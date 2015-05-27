class ShowcaseDecorator < Draper::Decorator
  delegate :id, :title, :subtitle, :description, to: :object

  def sections
    SectionQuery.new(object.sections).ordered
  end

  def honeypot_image_url
    if object.honeypot_image
      object.honeypot_image.json_response["contentUrl"]
    else
      {}
    end
  end
end

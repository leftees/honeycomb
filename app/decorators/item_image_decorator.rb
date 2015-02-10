class ItemImageDecorator < Draper::Decorator

  def title
    if object
      object.title
    else
      nil
    end
  end

  def render(style_name = nil, options = {})
    if object && style = style_with_fallback(style_name)
      h.image_tag(style.src, options)
    else
      nil
    end
  end

  def style_with_fallback(style_name)
    style(style_name) || original_style
  end

  def original_style
    style(:original)
  end

  def dzi
    object.dzi
  end

  def style(style_name)
    object.style(style_name)
  end
end

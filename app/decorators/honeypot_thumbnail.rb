class HoneypotThumbnail < Draper::Decorator
  attr_reader :honeypot_image

  def self.display(honeypot_image)
    new(honeypot_image).display
  end

  def initialize(honeypot_image)
    @honeypot_image = honeypot_image
  end

  def display
    h.react_component('Thumbnail', image: image_json)
  end


  private

    def image_json
      if honeypot_image
        honeypot_image.image_json
      else
        {}
      end
    end

end

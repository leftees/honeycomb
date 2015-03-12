class SaveShowcase
  attr_reader :params, :showcase

  def self.call(showcase, params)
    new(showcase, params).save
  end

  def initialize(showcase, params)
    @params = params
    @showcase = showcase
  end

  def save
    showcase.attributes = params
    check_unique_id

    (showcase.save && update_honeypot_image)
  end

  private

    def check_unique_id
      if showcase.unique_id.nil?
        showcase.unique_id = CreateUniqueId.call(showcase)
      end
    end

    def update_honeypot_image
      if params[:image]
        SaveHoneypotImage.call(showcase)
      else
        true
      end
    end

end


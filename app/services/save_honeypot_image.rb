class SaveHoneypotImage
  attr_reader :object, :image_field

  def self.call(*args)
    new(*args).save!
  end

  def initialize(object:, image_field: "image")
    @object = object
    @image_field = image_field
  end

  def save!
    response = send_request

    if response && update_image_server(response)
      honeypot_image
    else
      false
    end
  end

  private

  def honeypot_image
    object.honeypot_image || object.build_honeypot_image
  end

  def update_image_server(request)
    body = request.body.with_indifferent_access
    honeypot_image.json_response = body

    # I realize this is ugly, but it's either this or add this image status to
    # all other objects that use honeypot. This will all be resolved whenever we
    # refactor/normalize the other models by pulling out all of the image data into
    # an image or media entity, so this seems to introduce less tech debt than
    # adding to all.
    if object.respond_to?(:image_status)
      object.image_status = "image_ready"
    end
    honeypot_image.save && object.save
  end

  def send_request
    response = connection.post("/api/images", post)
    if response.success?
      response
    else
      false
    end
  end

  def connection
    @connection ||= Faraday.new(api_url) do |f|
      f.request :multipart
      f.request :url_encoded
      f.adapter :net_http
      f.response :json, content_type: "application/json"
    end
  end

  def group_id
    if object.respond_to?(:collection)
      object.collection.id
    else
      object.id
    end
  end

  def item_id
    object.id
  end

  def object_image
    object.send(image_field)
  end

  def upload_image
    Faraday::UploadIO.new(object_image.path, object_image.content_type)
  end

  def post
    { application_id: "honeycomb", group_id: group_id, item_id: item_id, image: upload_image }
  end

  def api_url
    Rails.configuration.settings.honeypot_url
  end
end

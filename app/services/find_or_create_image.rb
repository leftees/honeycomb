class FindOrCreateImage
  attr_reader :file, :collection_id

  def self.call(file:, collection_id:)
    new(file: file, collection_id: collection_id).find_or_create
  end

  def initialize(file:, collection_id:)
    @file = file
    @collection_id = collection_id
  end

  def find_or_create
    # Not sure if there is a simpler way to get paperclip to generate the fingerprint without creating a new Image
    # and processing all of the styles
    new_image = Image.new(image: file, collection_id: collection_id)
    found_image = Image.where(collection_id: collection_id, image_fingerprint: new_image.image_fingerprint).take
    image = found_image.nil? ? new_image : found_image
    if image.save
      image
    else
      false
    end
  end
end

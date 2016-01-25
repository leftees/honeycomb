class SaveCollection
  attr_reader :params, :collection

  def self.call(collection, params)
    new(collection, params).save
  end

  def initialize(collection, params)
    @params = params
    @collection = collection
  end

  def save
    fix_image_param!
    fix_url!
    collection.attributes = params
    check_unique_id
    if collection.save && process_uploaded_image
      ensure_configuration_setup
      true
    else
      false
    end
  end

  private

  def check_unique_id
    CreateUniqueId.call(collection)
  end

  def fix_image_param!
    # sometimes the form is sending an empty image value and this is causing paperclip to delete the image.
    params.delete(:uploaded_image) if params[:uploaded_image].nil?
  end

  def fix_url!
    if params[:url].present?
      params[:url] = "http://#{params[:url]}" unless params[:url][/^https?/]
    end
  end

  def process_uploaded_image
    if params[:uploaded_image]
      QueueJob.call(ProcessImageJob, object: collection)
    else
      true
    end
  end

  def ensure_configuration_setup
    CreateCollectionConfiguration.call(collection)
  end
end

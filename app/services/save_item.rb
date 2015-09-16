class SaveItem
  attr_reader :params, :item

  def self.call(item, params)
    new(item, params).save
  end

  def initialize(item, params)
    @params = params
    @item = item
  end

  def save
    fix_image_param!

    item.attributes = params
    pre_process_name
    check_unique_id
    check_user_defined_id

    if item.save && process_uploaded_image
      item
    else
      false
    end
  end

  private

  def pre_process_name
    if name_should_be_filename?
      item.name = GenerateNameFromFilename.call(item.uploaded_image_file_name)
    end

    item.sortable_name = SortableNameConverter.convert(item.name)
  end

  def name_should_be_filename?
    item.new_record? && item.name.blank?
  end

  # Sets the user defined id to the unique id if none is given
  def check_user_defined_id
    unless item.user_defined_id.present?
      item.user_defined_id = item.unique_id
    end
  end

  def fix_image_param!
    # sometimes the form is sending an empty image value and this is causing paperclip to delete the image.
    params.delete(:uploaded_image) if params[:uploaded_image].nil?
  end

  def process_uploaded_image
    if params[:uploaded_image]
      item.image_processing!
      QueueJob.call(ProcessImageJob, object: item)
    else
      true
    end
  end

  def check_unique_id
    CreateUniqueId.call(item)
  end
end

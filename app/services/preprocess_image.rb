class PreprocessImage
  MAX_PIXELS = 16000000
  attr_reader :paperclip_attachment

  def self.call(paperclip_attachment)
    new(paperclip_attachment).process
  end

  def initialize(paperclip_attachment)
    @paperclip_attachment = paperclip_attachment
  end

  def process
    if processing_needed?
      preprocess_attachment
    end
    attachment_path
  end

  private

  def preprocess_attachment
    processor_attachment.reprocess!
  end

  def uploaded_image
    paperclip_attachment
  end

  def processing_needed?
    uploaded_image.exists? && (tiff? || gif? || exceeds_max_pixels?)
  end

  def tiff?
    uploaded_image.content_type == "image/tiff"
  end

  def gif?
    uploaded_image.content_type == "image/gif"
  end

  def exceeds_max_pixels?
    original_pixels > MAX_PIXELS
  end

  def original_dimensions
    @original_dimensions ||= FastImage.size(uploaded_image.path)
  end

  def original_pixels
    original_dimensions.inject(:*)
  end

  def processor_attachment
    @processor_attachment ||= Paperclip::Attachment.new(:uploaded_image, uploaded_image.instance, processor_options)
  end

  def processor_options
    new_options = uploaded_image.options.clone
    new_options[:styles] = new_options[:styles].merge(processed: processor_style)
    new_options
  end

  def processor_style
    style = "#{MAX_PIXELS}@"
    if tiff?
      style = [style, :jpg]
    elsif gif?
      style = [style, :png]
    end
    style
  end

  def processed_path
    @processed_path ||= processor_attachment.path(:processed)
  end

  def attachment_path
    if processing_needed?
      processed_path
    else
      uploaded_image.path
    end
  end
end

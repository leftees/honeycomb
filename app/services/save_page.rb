class SavePage
  attr_reader :page, :params

  def self.call(page, params)
    new(page, params).save
  end

  def initialize(page, params)
    @page = page
    @params = params
  end

  def save
    process_image
    page.attributes = params
    check_unique_id
    if page.save
      AssociatePageWithItems.call(@page)
      page
    else
      false
    end
  end

  private

  def check_unique_id
    CreateUniqueId.call(page)
  end

  def process_image
    if params[:uploaded_image]
      page.image = FindOrCreateImage.call(file: params[:uploaded_image], collection_id: page.collection_id)
      params.delete(:uploaded_image)
    end
  end
end

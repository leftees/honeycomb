class AssociatePageWithItems
  def self.call(page)
    new(page).associate!
  end

  def initialize(page)
    @page = page
  end

  def associate!
    ActiveRecord::Base.transaction do
      DestroyPageItemAssociations.call(page_id: @page.id)
      CreatePageItemAssociations.call(item_ids: derive_item_ids, page_id: @page.id)
    end
  end

  private

  def derive_item_ids
    parsed_page = ParsePage.call(@page)
    parsed_page.css(".hc_page_image").map { |image_element| Item.where(unique_id: image_element.attribute("item_id").value).take! }
  end
end

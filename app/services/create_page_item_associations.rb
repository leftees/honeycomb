class CreatePageItemAssociations
  def self.call(item_ids: [], page_id:)
    new(item_ids: item_ids, page_id: page_id).create!
  end

  def initialize(item_ids: [], page_id:)
    @items = Item.find(create_array(item_ids))
    @page = Page.find(page_id)
  end

  def create!
    @page.items = @items
  end

  private

  def create_array(item_list)
    if item_list.is_a? Array
      item_list
    else
      [item_list]
    end
  end
end

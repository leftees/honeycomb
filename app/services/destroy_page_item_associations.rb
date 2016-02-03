class DestroyPageItemAssociations
  def self.call(page_id:)
    new(page_id: page_id).delete!
  end

  def initialize(page_id:)
    @page = Page.find(page_id)
  end

  def delete!
    @page.items.delete_all
    if @page.items.count == 0
      return 1
    end
    nil
  end
end

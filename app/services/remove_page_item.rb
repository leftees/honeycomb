class RemovePageItem
  def self.call(page, item)
    new(page, item).remove!
  end

  def initialize(page, item)
    @page = page
    @parsed_page = Nokogiri::HTML::DocumentFragment.parse(@page.content)
    @item = item
    get_element
  end

  def remove!
    @target_element.remove
    @page.content = @parsed_page.to_html
    @page.save!
  end

  private

  def get_element
    @parsed_page.css(".hc_page_image").each do |image_element|
      item_unique_id = image_element.attribute("item_id").value
      if item_unique_id == @item.unique_id
        @target_element ||= image_element
      end
    end
  end
end

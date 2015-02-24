class ReorderSections
  attr_reader :current_items_in_order, :update_item

  def self.call(current_items_in_order, update_item)
    new(current_items_in_order, update_item).reorder!
  end

  def initialize(current_items_in_order, update_item)
    @current_items_in_order = current_items_in_order
    @update_item = update_item
  end

  def reorder!
    res = current_items_in_order.to_a.insert(update_item.order, update_item).compact

    res.each_with_index do |s, index|
      check_and_update_order!(s, index)
    end

    true
  end

  private

    def check_and_update_order!(item, new_order)
      if item.order != new_order
        item.order = new_order
        item.save!
      end
    end

end

class FindOrCreateItem
  attr_reader :props, :item, :is_new_record, :is_changed, :is_valid
  private :is_new_record, :is_changed, :is_valid

  def initialize(props:)
    @item = nil
    @props = props
    @is_new_record = false
    @is_changed = false
    @is_valid = false
  end

  def by_user_defined_id
    find_or_create_by(criteria: { collection_id: props[:collection_id],
                                  user_defined_id: props[:user_defined_id] })
  end

  def new_record?
    is_new_record
  end

  # Returns true if the Item previously existed in the database and was changed.
  # This is different from just calling Item.changed? since a new item can appear
  # to have changed after assigning the attributes to the new item
  def changed?
    is_changed
  end

  def valid?
    is_valid
  end

  def save
    if is_valid && SaveItem.call(item, {})
      true
    else
      false
    end
  end

  def find_or_create_by(criteria:)
    @item = Item.find_or_create_by(criteria)
    @is_new_record = item.new_record?
    update_props
    @is_changed = !item.new_record? && item.changed?
    item
  end

  private

  def update_props
    item.assign_attributes(props)
    CreateUniqueId.call(item)
    @is_valid = item.valid?
  end
end

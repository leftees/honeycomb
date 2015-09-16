class CopyItemsUniqueIdToUserDefinedId < ActiveRecord::Migration
  def up
    connection.execute("UPDATE items SET user_defined_id = unique_id WHERE user_defined_id IS NULL OR user_defined_id = '';")
  end
end

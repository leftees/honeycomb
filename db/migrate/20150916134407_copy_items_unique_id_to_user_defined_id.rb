class CopyItemsUniqueIdToUserDefinedId < ActiveRecord::Migration
  def up
    connection.execute("UPDATE items SET user_defined_id = unique_id;")
  end
end

class AddUserDefinedIdToItems < ActiveRecord::Migration
  def change
    add_column :items, :user_defined_id, :string, null: false
  end
end

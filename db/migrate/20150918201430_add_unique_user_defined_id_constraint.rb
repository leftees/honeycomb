class AddUniqueUserDefinedIdConstraint < ActiveRecord::Migration
  def change
    add_index :items, [:collection_id, :user_defined_id], unique: true
  end
end

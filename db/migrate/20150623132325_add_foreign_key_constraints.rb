class AddForeignKeyConstraints < ActiveRecord::Migration
  def change
    add_foreign_key :exhibits, :collections
    add_foreign_key :collection_users, :collections
    add_foreign_key :items, :collections
    add_foreign_key :showcases, :exhibits
    add_foreign_key :sections, :showcases
    add_foreign_key :sections, :items
    add_foreign_key :items, :items, column: :parent_id
    add_foreign_key :collection_users, :users
  end
end

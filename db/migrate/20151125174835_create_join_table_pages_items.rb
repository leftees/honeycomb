class CreateJoinTablePagesItems < ActiveRecord::Migration
  def change
    create_join_table :pages, :items do |t|
      t.integer :item_id
      t.integer :page_id
      t.index [:page_id, :item_id]
      t.index [:item_id, :page_id]
    end
  end
end

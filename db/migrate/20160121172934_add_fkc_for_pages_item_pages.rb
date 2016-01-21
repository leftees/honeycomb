class AddFkcForPagesItemPages < ActiveRecord::Migration
  def up
    add_foreign_key :items_pages, :pages, column: :page_id
  end

  def down
    remove_foreign_key :items_pages, :pages, column: :page_id
  end
end

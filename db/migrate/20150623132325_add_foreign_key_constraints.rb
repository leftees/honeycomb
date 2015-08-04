class AddForeignKeyConstraints < ActiveRecord::Migration
  # Asserts that the given relation is empty
  def empty!(relation:, error_message:)
    if relation.count > 0
      raise "Unable to add foreign keys. #{error_message}"
    end
  end

  def change
    empty!(relation: Section.where("sections.item_id NOT IN (SELECT id FROM items)"),
           error_message: "A section was found that had no associated item.")

    empty!(relation: Section.where("sections.showcase_id NOT IN (SELECT id FROM showcases)"),
           error_message: "A section was found that had no associated showcase.")

    empty!(relation: Item.where("items.collection_id NOT IN (SELECT id FROM collections)"),
           error_message: "An item was found that had no associated collection.")

    empty!(relation: Item.where("items.parent_id IS NOT NULL AND items.parent_id NOT IN (SELECT id FROM items)"),
           error_message: "An item was found that had no associated parent item.")

    empty!(relation: Showcase.where("showcases.exhibit_id NOT IN (SELECT id FROM exhibits)"),
           error_message: "A showcase was found that had no associated exhibit.")

    empty!(relation: Exhibit.where("exhibits.collection_id NOT IN (SELECT id FROM collections)"),
           error_message: "An exhibit was found that had no associated collection.")

    empty!(relation: CollectionUser.where("collection_users.collection_id NOT IN (SELECT id FROM collections)"),
           error_message: "A collection user was found that had no associated collection.")

    empty!(relation: CollectionUser.where("collection_users.user_id NOT IN (SELECT id FROM users)"),
           error_message: "A collection user was found that had no associated user.")

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

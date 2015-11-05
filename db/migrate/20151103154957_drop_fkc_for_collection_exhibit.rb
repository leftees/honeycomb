class DropFkcForCollectionExhibit < ActiveRecord::Migration
  # Asserts that the given query results are empty
  def empty!(query:, error_message:)
    result = execute query
    if result.count > 0
      raise "Unable to add foreign keys. #{error_message}"
    end
  end

  def up
    remove_foreign_key :exhibits, :collections
  end

  def down
    empty!(query: "SELECT * FROM exhibits WHERE
                     exhibits.collection_id IS NULL OR exhibits.collection_id NOT IN (SELECT id FROM collections);",
           error_message: "Cannot re-add exhibit->collection constraint. An exhibit was found that had no associated collection.")

    add_foreign_key :exhibits, :collections
  end
end

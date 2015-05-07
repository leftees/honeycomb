module CacheKeys
  module Custom
    # Generator for editors_controller
    class Editors
      def index(collection:)
        CacheKeys::ActiveRecord.new.generate(record: [collection, collection.collection_users])
      end

      # Expects an array of hashes where the hash is of the format: {id:, label:, value:} for formatted_users
      def user_search(collection:, formatted_users:)
        CacheKeys::ActiveRecord.new.generate(record: [collection, formatted_users])
      end
    end
  end
end

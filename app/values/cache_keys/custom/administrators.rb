module CacheKeys
  module Custom
    # Generator for admin/administrators_controller
    class Administrators
      def index(users:)
        CacheKeys::ActiveRecord.new.generate(record: users)
      end
      # Expects an array of hashes where the hash is of the format: {id:, label:, value:} for formatted_users
      def user_search(formatted_users:)
        CacheKeys::ActiveRecord.new.generate(record: formatted_users)
      end
    end
  end
end

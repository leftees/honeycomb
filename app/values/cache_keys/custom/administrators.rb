module CacheKeys
  module Custom
    # Generator for admin/administrators_controller
    class Administrators
      def index(decorated_administrators:)
        CacheKeys::DecoratedActiveRecord.new.generate(record: decorated_administrators)
      end
      def user_search(users:)
        CacheKeys::ActiveRecord.new.generate(record: users)
      end
    end
  end
end

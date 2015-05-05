module CacheKeys
  module Custom
    # Generator for admin/administrators_controller
    class Administrators
      def index(decorated_administrators:)
        CacheKeys::DecoratedActiveRecord.new.generate(record: decorated_administrators)
      end
    end
  end
end

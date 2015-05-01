module CacheKeys
  class Generator
    def initialize(keyGenerator:, action: :generate)
      @generator = keyGenerator
      @action = action
    end

    def generate(*args)
      @generator.send(@action, args)
    end

    class Administrators
      def none(args)
      end

      def index(args)
        decoratedAdministrators = args[0]
        CacheKeys::DecoratedActiveRecord.new.generate(record: decoratedAdministrators)
      end
    end

    class V1Collections
      def none(args)
      end

      def index(args)
        collections = args[0]
        CacheKeys::ActiveRecord.new.generate(record: collections)
      end

      def show(args)
        collection = args[0]
        CacheKeys::ActiveRecord.new.generate(record: collection)
      end
    end
  end
end

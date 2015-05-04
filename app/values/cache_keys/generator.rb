module CacheKeys
  # Generator handles routing the cache key generation to a given
  # key generator and action for that generator
  class Generator
    def initialize(keyGenerator:, action: :generate)
      @generator = keyGenerator
      @action = action
    end

    def generate(*args)
      key = @generator.send(@action, *args)
      #print @generator.class.name + "." + @action + "='" + key + "'\n"
    end

    # Generator for admin/administrators_controller
    class Administrators
      def index(decoratedAdministrators:)
        CacheKeys::DecoratedActiveRecord.new.generate(record: decoratedAdministrators)
      end
    end

    # Generator for v1/collections_controller
    class V1Collections
      def index(collections:)
        CacheKeys::ActiveRecord.new.generate(record: collections)
      end

      def show(collection:)
        CacheKeys::ActiveRecord.new.generate(record: collection)
      end
    end

    # Generator for v1/items_controller
    class V1Items
      def index(collection:, items:)
        CacheKeys::ActiveRecord.new.generate(record: [collection, items])
      end

      def show(item:, collection:, children:)
        CacheKeys::ActiveRecord.new.generate(record: [item, collection, children])
      end
    end

    # Generator for v1/sections_controller
    class V1Sections
      def show(section:, item:, itemChildren:, nextSection:, previousSection:, collection:, showcase:)
        CacheKeys::ActiveRecord.new.generate(record: [section, item, itemChildren, nextSection, previousSection, collection, showcase])
      end
    end

    # Generator for v1/showcases_controller
    class V1Showcases
      def index(collection:, showcases:)
        CacheKeys::ActiveRecord.new.generate(record: [collection, showcases])
      end

      def show(showcase:, collection:, sections:, items: )
        CacheKeys::ActiveRecord.new.generate(record: [showcase, collection, sections, items])
      end
    end
  end
end

module CacheKeys
  # Generator handles routing the cache key generation to a given
  # key generator and action for that generator
  class Generator
    def initialize(key_generator:, action: :generate, **args)
      @generator = key_generator.new
      @action = action
      @args = args
    end

    def generate
      # print @generator.class.name + "." + @action + "='" + @generator.send(@action, **@args) + "'\n"
      @generator.send(@action, **@args)
    end

    # Generator for admin/administrators_controller
    class Administrators
      def index(decorated_administrators:)
        CacheKeys::DecoratedActiveRecord.new.generate(record: decorated_administrators)
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
      def index(collection:)
        CacheKeys::ActiveRecord.new.generate(record: [collection, collection.items])
      end

      def show(item:)
        CacheKeys::ActiveRecord.new.generate(record: [item, item.collection, item.children])
      end
    end

    # Generator for v1/sections_controller
    class V1Sections
      def show(decorated_section:)
        CacheKeys::ActiveRecord.new.generate(record: [decorated_section.object,
                                                      decorated_section.item,
                                                      decorated_section.item_children,
                                                      decorated_section.next,
                                                      decorated_section.previous,
                                                      decorated_section.collection,
                                                      decorated_section.showcase])
      end
    end

    # Generator for v1/showcases_controller
    class V1Showcases
      def index(collection:)
        CacheKeys::ActiveRecord.new.generate(record: [collection, collection.showcases])
      end

      def show(showcase:)
        CacheKeys::ActiveRecord.new.generate(record: [showcase, showcase.collection, showcase.sections, showcase.items])
      end
    end
  end
end

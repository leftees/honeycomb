module CacheKeys
  # Generator handles routing the cache key generation to a given
  # key generator and action for that generator
  class Generator
    def initialize(keyGenerator:, action: :generate, **args)
      @generator = keyGenerator.new
      @action = action
      @args = args
    end

    def generate
      # print @generator.class.name + "." + @action + "='" + @generator.send(@action, **@args) + "'\n"
      @generator.send(@action, **@args)
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
      def index(collection:)
        CacheKeys::ActiveRecord.new.generate(record: [collection, collection.items])
      end

      def show(item:)
        CacheKeys::ActiveRecord.new.generate(record: [item, item.collection, item.children])
      end
    end

    # Generator for v1/sections_controller
    class V1Sections
      def show(decoratedSection:)
        CacheKeys::ActiveRecord.new.generate(record: [decoratedSection.object,
                                                      decoratedSection.item,
                                                      decoratedSection.item_children,
                                                      decoratedSection.next,
                                                      decoratedSection.previous,
                                                      decoratedSection.collection,
                                                      decoratedSection.showcase])
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

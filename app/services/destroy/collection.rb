module Destroy
  class Collection
    attr_reader :destroy_collection_user, :destroy_exhibit, :destroy_item

    # Allow injecting destroy objects to use when cascading
    def initialize(destroy_collection_user: nil, destroy_exhibit: nil, destroy_item: nil)
      @destroy_collection_user = destroy_collection_user || Destroy::CollectionUser.new
      @destroy_exhibit = destroy_exhibit || Destroy::Exhibit.new
      @destroy_item = destroy_item || Destroy::Item.new
    end

    # Destroy the object only
    def destroy!(collection:)
      collection.destroy!
    end

    # Destroys this object and all associated objects.
    def cascade!(collection: collection)
      ActiveRecord::Base.transaction do
        collection.collection_users.each do |child|
          @destroy_collection_user.cascade!(collection_user: child)
        end
        if collection.exhibit
          @destroy_exhibit.cascade!(exhibit: collection.exhibit)
        end
        collection.items.each do |child|
          @destroy_item.cascade!(item: child)
        end
        collection.destroy!
      end
    end
  end
end
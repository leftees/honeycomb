module V1
  class ShowcasesController < APIController
    def index
      collection = CollectionQuery.new.public_find(params[:collection_id])
      @collection = CollectionJSONDecorator.new(collection)
      fresh_when([collection, collection.showcases])
    end

    def show
      showcase = ShowcaseQuery.new.public_find(params[:id])
      @showcase = ShowcaseJSONDecorator.new(showcase)
      fresh_when([showcase, showcase.collection, showcase.sections, showcase.items])
    end
  end
end

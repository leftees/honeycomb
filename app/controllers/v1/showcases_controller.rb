module V1
  class ShowcasesController < APIController
    def index
      @collection = CollectionJSONDecorator.new(CollectionQuery.new.public_find(params[:collection_id]))
      fresh_when(@collection)
    end

    def show
      @showcase = ShowcaseJSONDecorator.new(ShowcaseQuery.new.public_find(params[:id]))
      fresh_when(@showcase)
    end
  end
end

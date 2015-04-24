module API
  class CollectionsController < APIController
    def index
      @collections = Collection.all
      if stale?(@collections)
        respond_to do |format|
          format.json { render json: GenerateCollectionJSON.call(@collections) }
        end
      end
    end

    def show
      @collection = Collection.find(params[:id])

      if stale?(@collection)
        respond_to do |format|
          format.json { render json: GenerateCollectionJSON.call(@collection) }
        end
      end
    end
  end
end

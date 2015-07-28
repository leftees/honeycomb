module V1
  class SearchController < APIController
    def index
      search_arguments = {
        q: params[:q],
        facets: params[:facets],
        sort: params[:sort],
        rows: params[:rows],
        start: params[:start],
        collection: collection
      }
      @search = Waggle::Search::Query.new(search_arguments).result
    end

    private

    def collection
      if params[:collection_id]
        CollectionQuery.new.any_find(params[:collection_id])
      end
    end
  end
end

module V1
  class MetadataFieldsController < APIController
    def index
      collection = CollectionQuery.new.any_find(params[:collection_id])
      @configuration = CollectionConfigurationQuery.new(collection).find
      @configuration = V1::MetadataConfigurationJSON.new(@configuration)

      respond_to do |format|
        format.json { render json: @configuration.to_json }
      end
    end

    def update
      @collection = CollectionQuery.new.any_find(params[:collection_id])

      return if rendered_forbidden?(@collection)

      @return_value = Metadata::UpdateConfigurationField.call(@collection, params[:field])

      respond_to do |format|
        format.json { render json: { status: @return_value }.to_json }
      end
    end
  end
end

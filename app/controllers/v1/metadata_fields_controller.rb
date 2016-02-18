module V1
  class MetadataFieldsController < APIController
    def update
      @collection = CollectionQuery.new.any_find(params[:collection_id])

      return if rendered_forbidden?(@collection)

      @return_value = :success
      if !Metadata::UpdateConfigurationField.call(@collection, params[:id], params[:fields])
        @return_value = :unprocessable_entity
      end

      respond_to do |format|
        format.json { render json: { status: @return_value }.to_json }
      end
    end

    def create
      @collection = CollectionQuery.new.any_find(params[:collection_id])

      return if rendered_forbidden?(@collection)

      @return_value = :success
      if !Metadata::CreateConfigurationField.call(@collection, params[:fields])
        @return_value = :unprocessable_entity
      end

      respond_to do |format|
        format.json { render json: { status: @return_value }.to_json }
      end
    end
  end
end

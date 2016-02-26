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
      result = Metadata::CreateConfigurationField.call(@collection, params[:fields])
      if result
        render json: { status: :success, field: result }.to_json
      else
        render json: { status: :unprocessable_entity, field: params[:fields] }.to_json
      end
    end
  end
end

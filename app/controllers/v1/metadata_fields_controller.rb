module V1
  class MetadataFieldsController < APIController
    def update
      @collection = CollectionQuery.new.any_find(params[:collection_id])

      return if rendered_forbidden?(@collection)

      @return_value = Metadata::UpdateConfigurationField.call(@collection, params[:id], params[:fields])

      respond_to do |format|
        format.json { render json: { status: @return_value }.to_json }
      end
    end
  end
end

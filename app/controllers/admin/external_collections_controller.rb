module Admin
  class ExternalCollectionsController < ApplicationController
    def index
      @external_collections = Exhibition.all
    end

    def new
      check_admin_or_admin_masquerading_permission!
      @form_action = admin_external_collections_path
      @external_collection = Exhibition.new
    end

    def create
      check_admin_or_admin_masquerading_permission!
      build_collection.save!
      redirect_to action: "index"
    end

    def edit
      exhibit = Exhibit.find(params[:id])
      @form_action = admin_external_collection_path(exhibit)
      @external_collection = Exhibition.new(exhibit: exhibit)
      @honeypot_image = exhibit.honeypot_image[:json_response]["thumbnail/small"]["contentUrl"]
    end

    def update
      exhibition = Exhibition.new(exhibit: Exhibit.find(params[:id]))
      update_collection(exhibition).save!
      redirect_to action: "index"
    end

    def destroy
      exhibition = Exhibition.new(exhibit: Exhibit.find(params[:id]))
      Destroy::Collection.new.cascade!(collection: exhibition.collection)
      redirect_to action: "index"
    end

    private

    def build_collection
      exhibition = Exhibition.new
      exhibition.name_line_1 = params[:external_collection]["name"]
      exhibition.url = params[:external_collection]["url"]
      exhibition.published = true
      exhibition.uploaded_image = params[:external_collection]["uploaded_image"]
      exhibition.description = params[:external_collection]["description"]
      exhibition
    end

    def update_collection(exhibition)
      exhibition.name_line_1 = params[:external_collection]["name"]
      exhibition.url = params[:external_collection]["url"]
      exhibition.uploaded_image = params[:external_collection]["uploaded_image"]
      exhibition.description = params[:external_collection]["description"]
      exhibition
    end
  end
end

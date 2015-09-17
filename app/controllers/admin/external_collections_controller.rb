module Admin
  class ExternalCollectionsController < ApplicationController
    def index
      @external_collections = Exhibition.all
    end

    def new
      check_admin_or_admin_masquerading_permission!
      @external_collection = Exhibition.new
    end

    def create
      check_admin_or_admin_masquerading_permission!
    end
  end
end

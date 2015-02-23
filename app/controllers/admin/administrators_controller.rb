module Admin
  class AdministratorsController < ApplicationController
    def index
      check_admin_or_admin_masquerading_permission!
      @administrators = AdministratorQuery.new.list
    end

    def user_search
      check_admin_or_admin_masquerading_permission!

      search_results = PersonAPISearch.call(params[:q])
      respond_to do |format|
        format.any { render json: search_results.to_json, content_type: "application/json" }
      end
    end
  end
end

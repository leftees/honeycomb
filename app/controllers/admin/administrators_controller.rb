module Admin
  class AdministratorsController < ApplicationController
    def index
      check_admin_permission!
      administrators = AdministratorQuery.new.list
      @administrators = AdministratorListDecorator.new(administrators)

      cache_key = CacheKeys::Generator.new(key_generator: CacheKeys::Custom::Administrators,
                                           action: "index",
                                           users: administrators)
      fresh_when(etag: cache_key.generate)
    end

    def create
      check_admin_permission!

      user =  FindOrCreateUser.call(create_params[:username])
      if user && SetAdminOnUser.call(user)
        @user = AdministratorDecorator.new(user)
        respond_to do |format|
          format.any { render json: @user.to_hash, status: 200 }
        end
      else
        respond_to do |format|
          format.any { render json: { status: "error" }, status: 500 }
        end
      end
    end

    def destroy
      check_admin_permission!

      user = AdministratorQuery.new.find(params[:id])
      RevokeAdminOnUser.call(user)
      redirect_to admin_administrators_path
    end

    def user_search
      check_admin_permission!

      search_results = PersonAPISearch.call(params[:q])
      cache_key = CacheKeys::Generator.new(key_generator: CacheKeys::Custom::Administrators,
                                           action: "user_search",
                                           formatted_users: search_results)
      if stale?(etag: cache_key.generate)
        respond_to do |format|
          format.any { render json: search_results.to_json, content_type: "application/json" }
        end
      end
    end

    private

    def create_params
      params.require(:user).permit(:username)
    end
  end
end

module API
  class APIController < ApplicationController
    skip_before_filter :redirect_to_sign_in

    before_action :set_access

    private

      def set_access
        response.headers["Access-Control-Allow-Origin"] = "*"
      end
  end
end

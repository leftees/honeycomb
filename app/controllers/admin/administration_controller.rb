module Admin
  class AdministrationController < ApplicationController
    def index
      check_admin_permission!
    end
  end
end

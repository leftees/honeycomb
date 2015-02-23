module Admin
  class AdministratorsController < ApplicationController
    def index
      check_admin_or_admin_masquerading_permission!
      @administrators = AdministratorQuery.new.list
    end
  end
end

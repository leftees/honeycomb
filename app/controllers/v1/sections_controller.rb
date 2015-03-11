module V1
  class SectionsController < APIController

    def show
      @section = SectionQuery.new.public_find(params[:id])
    end
  end
end


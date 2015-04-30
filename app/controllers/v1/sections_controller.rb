module V1
  class SectionsController < APIController
    def show
      @section = SectionJSONDecorator.new(SectionQuery.new.public_find(params[:id]))
      fresh_when([@section, @section.item, @section.collection, @section.showcase])
    end
  end
end

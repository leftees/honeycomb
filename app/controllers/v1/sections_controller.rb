module V1
  class SectionsController < APIController
    def show
      section = SectionQuery.new.public_find(params[:id])
      @section = SectionJSONDecorator.new(section)

      cache_key = CacheKeys::Generator.new(key_generator: CacheKeys::Custom::V1Sections,
                                           action: "show",
                                           decorated_section: @section)
      fresh_when(etag: cache_key.generate)
    end
  end
end

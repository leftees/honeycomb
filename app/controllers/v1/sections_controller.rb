module V1
  class SectionsController < APIController
    def show
      section = SectionQuery.new.public_find(params[:id])
      @section = SectionJSONDecorator.new(section)

      cache_key = CacheKeys::Generator.new(keyGenerator: CacheKeys::Generator::V1Sections,
                                           action: "show",
                                           decoratedSection: @section)
      fresh_when(etag: cache_key.generate)
    end
  end
end

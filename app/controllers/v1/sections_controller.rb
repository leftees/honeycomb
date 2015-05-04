module V1
  class SectionsController < APIController
    def show
      section = SectionQuery.new.public_find(params[:id])
      @section = SectionJSONDecorator.new(section)

      keyGen = CacheKeys::Generator::V1Sections.new
      cacheKey = CacheKeys::Generator.new(keyGenerator: keyGen, action: "show")
      fresh_when(etag: cacheKey.generate(section: section,
                                         item: section.item,
                                         itemChildren: section.item.children,
                                         nextSection: @section.next,
                                         previousSection: @section.previous,
                                         collection: section.collection,
                                         showcase: section.showcase))
    end
  end
end

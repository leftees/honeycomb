# Calls the appropriate decorator for the given site object
module V1
  class SiteObjectsJSONDecorator < Draper::Decorator
    def self.display(site_object, json)
      case site_object.class.name
      when "Showcase"
        V1::ShowcaseJSONDecorator.display(site_object, json)
      when "Item"
        V1::ItemJSONDecorator.display(site_object, json)
      when "Page"
        V1::PageJSONDecorator.display(site_object, json)
      else
        raise "Unsupported object type #{site_object.class.name}"
      end
    end
  end
end

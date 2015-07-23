module Destroy
  class Exhibit
    attr_reader :destroy_showcase

    # Allow injecting destroy objects to use when cascading
    def initialize(destroy_showcase: nil)
      @destroy_showcase = destroy_showcase || Destroy::Showcase.new
    end

    # Destroy the object only
    def destroy!(exhibit:)
      exhibit.destroy!
    end

    # Destroys this object and all associated objects.
    def cascade!(exhibit: exhibit)
      ActiveRecord::Base.transaction do
        exhibit.showcases.each do |child|
          @destroy_showcase.cascade!(showcase: child)
        end
        exhibit.destroy!
      end
    end
  end
end

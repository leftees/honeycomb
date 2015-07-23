module Destroy
  class Item
    attr_reader :destroy_section

    # Allow injecting destroy objects to use when cascading
    def initialize(destroy_section: nil)
      @destroy_section = destroy_section || Destroy::Section.new
    end

    # Destroy the object only
    def destroy!(item:)
      item.destroy!
    end

    # Destroys this object and all associated objects.
    def cascade!(item: item)
      ActiveRecord::Base.transaction do
        item.sections.each do |child|
          @destroy_section.cascade!(section: child)
        end
        item.children.each do |child|
          cascade!(item: child)
        end
        item.destroy!
      end
    end
  end
end

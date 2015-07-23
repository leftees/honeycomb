module Destroy
  class Section
    # Destroy the object only
    def destroy!(section:)
      section.destroy!
    end

    # There are no additional cascades for Sections,
    # so destroys the object only
    def cascade!(section:)
      section.destroy!
    end
  end
end

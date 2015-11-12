module Destroy
  class Page
    # Destroy the object only
    def destroy!(page:)
      page.destroy!
    end

    # There are no additional cascades for Pages,
    # so destroys the object only
    def cascade!(page:)
      page.destroy!
    end
  end
end

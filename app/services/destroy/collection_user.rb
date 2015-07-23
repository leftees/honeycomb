module Destroy
  class CollectionUser
    # Destroy the object only
    def destroy!(collection_user:)
      collection_user.destroy!
    end

    # There are no additional cascades for CollectionUser,
    # so destroys the object only
    def cascade!(collection_user:)
      collection_user.destroy!
    end
  end
end

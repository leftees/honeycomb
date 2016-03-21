module Destroy
  class CollectionConfiguration
    # Destroy the object only
    def destroy!(collection_configuration:)
      collection_configuration.destroy!
    end

    # There are no additional cascades for CollectionConfiguration,
    # so destroys the object only
    def cascade!(collection_configuration:)
      collection_configuration.destroy!
    end
  end
end

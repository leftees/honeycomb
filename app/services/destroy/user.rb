module Destroy
  class User
    attr_reader :destroy_collection_user

    # Allow injecting destroy objects to use when cascading
    def initialize(destroy_collection_user: nil)
      @destroy_collection_user = destroy_collection_user || Destroy::CollectionUser.new
    end

    # Destroy the object only
    def destroy!(user:)
      user.destroy!
    end

    # Destroys this object and all associated objects.
    def cascade!(user: user)
      ActiveRecord::Base.transaction do
        user.collection_users.each do |child|
          @destroy_collection_user.cascade!(collection_user: child)
        end
        user.destroy!
      end
    end
  end
end

class CollectionUserDecorator < Draper::Decorator
  def curator_hash
    {
      id: id,
      name: name,
      username: username,
      removeUrl: destroy_path
    }
  end

  def curator_json
    curator_hash.to_json
  end

  def id
    object.user_id
  end

  def name
    user.display_name
  end

  def username
    user.username
  end

  def destroy_path
    h.collection_curator_path(object.collection_id, object.user_id)
  end

  private
    def user
      object.user
    end
end

class CollectionUserListDecorator < Draper::CollectionDecorator
  def decorator_class
    CollectionUserDecorator
  end

  def curator_hashes
    decorated_collection.collect{|collection_user| collection_user.curator_hash}
  end
end

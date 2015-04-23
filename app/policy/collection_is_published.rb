class CollectionIsPublished

  def self.call(collection)
     new(collection).published? 
  end

  def initialize(collection)
     @collection = collection 
  end

  def published?
      @collection.published?        
  end

end
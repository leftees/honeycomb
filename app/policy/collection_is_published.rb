class CollectionIsPublished
   
    def self.call(collection)
       new(collection).is_published? 
    end

    def initialize(collection)
       @collection = collection 
    end

    def is_published?
        @collection.published?        
    end
    
    
end
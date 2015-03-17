class SaveCollection
  attr_reader :params, :collection

  def self.call(collection, params)
    new(collection, params).save
  end

  def initialize(collection, params)
    @params = params
    @collection = collection
  end

  def save
    collection.attributes = params

    if collection.save
      check_unique_id
      true
    else
      false
    end
  end


  private

    def check_unique_id
      if collection.unique_id.nil?
        collection.unique_id = CreateUniqueId.call(collection)
        collection.save
      end
    end
end

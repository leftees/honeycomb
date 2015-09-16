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
    check_unique_id

    if collection.save
      EnsureCollectionHasExhibit.call(collection)
      true
    else
      false
    end
  end

  private

  def check_unique_id
    CreateUniqueId.call(collection)
  end
end

class SiteObjectsQuery
  # Gets an array of all of the objects referenced by site_objects
  def all(collection:)
    site_objects_json(collection_id: collection.id).map do |site_object|
      get_object(site_object: site_object)
    end
  end

  # Gets an array of the objects and their type referenced by site_objects
  # Ex: [{type: "Showcase", object: <Showcase id: 1, name_line_1: "Test", ...>},...]
  def all_typed(collection:)
    site_objects_json(collection_id: collection.id).map do |site_object|
      { type: site_object[:type], object: get_object(site_object: site_object) }
    end
  end

  # Determines if an object exists in site_objects for its collection
  def exists?(collection_object:)
    type = collection_object.class.name
    id = collection_object.id
    site_objects_json(collection_id: collection_object.collection_id).detect do |site_object|
      if site_object[:type] == type && site_object[:id] == id
        return true
      end
    end
    false
  end

  # Given an object within the collection, this will find the next one in the list
  def next(collection_object:)
    type = collection_object.class.name
    id = collection_object.id
    site_objects_json(collection_id: collection_object.collection_id).each_cons(2) do |site_object, next_site_object|
      if site_object[:type] == type && site_object[:id] == id
        return get_object(site_object: next_site_object)
      end
    end
    nil
  end

  # Given an object within the collection, this will find the previous one in the list
  def previous(collection_object:)
    previous = nil
    type = collection_object.class.name
    id = collection_object.id
    site_objects_json(collection_id: collection_object.collection_id).each do |site_object|
      if site_object[:type] == type && site_object[:id] == id
        return previous.nil? ? nil : get_object(site_object: previous)
      end
      previous = site_object
    end
    nil
  end

  private

  attr_reader :collection

  # Returns an array of hashes of the form { :type, :id }
  # Ex: [{type: "showcase", id: 3},{ type: "showcase", id:1 }]
  def site_objects_json(collection_id:)
    collection = Collection.find(collection_id)
    if collection.nil?
      []
    else
      JSON.parse(collection.site_objects, symbolize_names: true)
    end
  end

  def get_object(site_object:)
    if supported_types.include?(site_object[:type])
      site_object[:type].constantize.find(site_object[:id])
    else
      raise "Unsupported object type #{site_object[:type]}."
    end
  end

  def supported_types
    ["Showcase", "Page"]
  end
end

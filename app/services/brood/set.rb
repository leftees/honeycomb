module Brood
  class Set
    attr_reader :base_path

    def initialize(base_path)
      @base_path = base_path
    end

    def data
      @data ||= JSON.parse(File.read(path("collections.json")))
    end

    def grow!
      grow_collections!
    end

    def grow_collections!
      data.each do |collection_name|
        grow_collection!(collection_name)
      end
    end

    def grow_collection!(collection_name)
      collection = Brood::Collection.new(path(collection_name))
      collection.grow!
    end

    def path(path_segment)
      File.join(base_path, path_segment)
    end
  end
end

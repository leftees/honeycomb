require 'net/http'

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

    def reset_solr!
      url = URI.parse("http://localhost:8982/solr/development/update?commit=true --data '<delete><query>*:*</query></delete>' -H 'Content-type:text/xml; charset=utf-8'")
      Net::HTTP::Get.new(url.to_s)

      commit_solr!

      Index::Item.index_all!(Item.all)
    end

    def commit_solr!
      url = URI.parse("http://localhost:8982/solr/development/update?commit=true")
      Net::HTTP::Get.new(url.to_s)
    end
  end
end

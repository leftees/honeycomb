module Waggle
  class Item
    attr_reader :data

    def initialize(data)
      @data = data
    end

    def id
      data.fetch("id")
    end

    def name
      data.fetch("name")
    end

    def name_facet
      name
    end

    def self.load(id)
      raw_data = File.read(Rails.root.join("spec/fixtures/v1/items/#{id}.json"))
      new(JSON.parse(raw_data).fetch("items"))
    end
  end
end

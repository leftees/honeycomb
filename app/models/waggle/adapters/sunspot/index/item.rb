module Waggle
  module Adapters
    module Sunspot
      module Index
        module Item
          include Waggle::Adapters::Sunspot::Index::Indexer

          def self.index_class
            Waggle::Item
          end

          def self.setup(configuration = default_configuration) # rubocop:disable Metrics/AbcSize
            reset!
            setup_index do
              configuration.fields.each do |field|
                if field.type == :date
                  time field.name, multiple: true
                elsif [:string, :html].include?(field.type)
                  text field.name
                else
                  raise "unknown type #{field.type}"
                end
              end
              configuration.facets.each do |facet|
                string "#{facet.name}_facet".to_sym, multiple: true
              end
              configuration.sorts.each do |sort|
                string "#{sort.name}_sort".to_sym, multiple: false
              end
              string :at_id, stored: true
              string :unique_id, stored: true
              string :collection_id, stored: true
              string :type, stored: true
              string :thumbnail_url, stored: true
              time :last_updated, stored: true
              text :name, stored: true
            end
          end

          def self.default_configuration
            ::Metadata::Configuration.item_configuration
          end
        end
      end
    end
  end
end

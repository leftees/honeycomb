module Waggle
  module Adapters
    module Solr
      module Search
        class Hit
          attr_reader :solr_doc
          private :solr_doc

          def initialize(solr_doc)
            @solr_doc = solr_doc
          end

          def id
            fetch(:id)
          end

          def name
            fetch(:name_t)
          end

          def at_id
            fetch(:at_id_s)
          end

          def unique_id
            fetch(:unique_id_s)
          end

          def collection_id
            fetch(:collection_id_s)
          end

          def type
            fetch(:type_s)
          end

          def thumbnail_url
            fetch(:thumbnail_url_s)
          end

          def last_updated
            fetch(:last_updated_dt)
          end

          private

          def fetch(field)
            value = solr_doc.fetch(field.to_s, nil)
            if value.is_a?(Array)
              value.first
            else
              value
            end
          end

          def fetch_raw(base_field)
            solr_doc.fetch("#{base_field}_t", nil) || solr_doc.fetch("#{base_field}_s", nil) || solr_doc.fetch("#{base_field}_dt", nil)
          end
        end
      end
    end
  end
end

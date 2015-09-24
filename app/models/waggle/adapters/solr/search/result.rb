module Waggle
  module Adapters
    module Solr
      module Search
        class Result
          FIELD_BOOSTS = {
            name: 10,
            alternate_name: 5,
            subject: 3,
            creator: 2,
          }

          attr_reader :query

          def initialize(query: query)
            @query = query
          end

          def hits
            @hits ||= solr_docs.map { |solr_doc| Waggle::Adapters::Solr::Search::Hit.new(solr_doc) }
          end

          def facets
            if @facets.nil?
              @facets = configuration.facets.map do |facet|
                facet_rows = solr_facet(facet.name)
                if facet_rows.present?
                  Waggle::Adapters::Solr::Search::Facet.new(facet_config: facet, facet_rows: facet_rows)
                end
              end
              @facets.compact!
            end
            @facets
          end

          def page
            (query.start / per_page) + 1
          end

          def per_page
            query.rows
          end

          def total
            solr_response.fetch("numFound", 0)
          end

          def result
            @result ||= connection.paginate(
              page,
              per_page,
              "select",
              params: solr_params,
            )
          end

          private

          def solr_params
            {
              q: query.q,
              fl: "score *",
              qf: solr_query_fields,
              pf: solr_phrase_fields,
              fq: solr_filters,
              sort: solr_sort,
              spellcheck: true,
              facet: true,
              :"facet.field" => facet_fields,
            }
          end

          def solr_query_fields
            fields = []
            FIELD_BOOSTS.each do |field_name, boost|
              [:unstem_search, :t].each do |suffix|
                fields << "#{field_name}_#{suffix}^#{boost}"
              end
            end
            fields << "text"
            fields << "text_unstem_search"
            fields.join " "
          end

          def solr_phrase_fields
            solr_query_fields
          end

          def facet_fields
            configuration.facets.map do |facet|
              field = "#{facet.name}_facet"
              "{!ex=#{field}}#{field}"
            end
          end

          def solr_sort
            if sort_field
              "#{sort_field.field_name}_sort #{sort_field.direction}"
            else
              "score desc"
            end
          end

          def solr_filters
            filters = []
            query.filters.each do |key, value|
              filters.push(format_filter("#{key}_s", value))
            end
            configuration.facets.each do |facet|
              if value = query.facet(facet.name)
                filters.push(format_filter("#{facet.name}_facet", value, true))
              end
            end
            filters
          end

          def format_filter(field, value, tag = false)
            filter = "#{field}:\"#{value}\""
            if tag
              filter = "{!tag=#{field}}#{filter}"
            end
            filter
          end

          def connection
            Waggle::Adapters::Solr.session.connection
          end

          def solr_docs
            solr_response.fetch("docs", [])
          end

          def solr_response
            result.fetch("response", {})
          end

          def solr_facets
            result.fetch("facet_counts", {}).fetch("facet_fields", {})
          end

          def solr_facet(field)
            solr_facets.fetch("#{field}_facet", nil)
          end

          def sort_field
            @sort_field ||= query.sort_field
          end

          def configuration
            query.configuration
          end
        end
      end
    end
  end
end

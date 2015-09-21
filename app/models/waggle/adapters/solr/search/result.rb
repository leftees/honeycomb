module Waggle
  module Adapters
    module Solr
      module Search
        class Result
          attr_reader :query, :filters

          def initialize(query: query)
            @query = query
          end

          def hits
            @hits ||= solr_docs.map { |solr_doc| Waggle::Adapters::Solr::Search::Hit.new(solr_doc) }
          end

          def facets
            []
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
              fq: filters,
              sort: sort,
            }
          end

          def sort
            if sort_field
              "#{sort_field.field_name}_sort #{sort_field.direction}"
            else
              "score asc"
            end
          end

          def filters
            filters = []
            query.filters.each do |key, value|
              filters.push(format_filter("#{key}_s", value))
            end
            filters.join(" ")
          end

          def format_filter(field, value)
            "+#{field}:\"#{value}\""
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

          # def search # rubocop:disable Metrics/AbcSize
          #   if @search.nil?
          #     Waggle::Adapters::Sunspot::Index::Item.setup(configuration)
          #     @search = ::Sunspot.search Waggle::Item do
          #       fulltext query.q
          #       paginate page: page, per_page: per_page
          #
          #       filters.each do |key, value|
          #         with(key, value)
          #       end
          #
          #       if sort_field
          #         order_by("#{sort_field.name}_sort", sort_field.direction)
          #       end
          #
          #       configuration.facets.each do |facet|
          #         facet_indexed_name = "#{facet.name}_facet".to_sym
          #         exclude_filters = []
          #         if value = query.facet(facet.name)
          #           exclude_filters << with(facet_indexed_name, value)
          #         end
          #         facet facet_indexed_name, exclude: exclude_filters
          #       end
          #     end
          #   end
          #   @search
          # end

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

module Waggle
  module Metadata
    class Set
      attr_reader :data, :configuration

      def initialize(data, configuration)
        @data = data
        @fields = {}
        @configuration = configuration
      end

      def value(field_name)
        if field(field_name)
          field(field_name).values.map(&:value)
        end
      end

      def field(field_name)
        if field?(field_name) && data.has_key?(field_name.to_s)
          @fields[field_name] ||= Waggle::Metadata::Field.new(data.fetch(field_name.to_s))
        end
      end

      def field?(field_name)
        configuration.field?(field_name)
      end

      def facet(facet_name)
        facet = configuration.facet(facet_name)
        value(facet.field_name)
      end

      def facet?(facet_name)
        configuration.facet?(facet_name)
      end

      def sort(sort_name)
        sort = configuration.sort(sort_name)
        sort_value = value(sort.field_name)
        if sort_value.present?
          sort_value.join(" ")
        end
      end

      def sort?(sort_name)
        configuration.sort?(sort_name)
      end
    end
  end
end

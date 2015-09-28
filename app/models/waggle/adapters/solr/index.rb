module Waggle
  module Adapters
    module Solr
      module Index
        SUFFIXES = {
          datetime: :dt,
          facet: :facet,
          sort: :sort,
          string: :s,
          text: :t,
        }.freeze

        def self.datetime_field_name(name)
          field_name_with_suffix(name, :datetime)
        end

        def self.facet_field_name(name)
          field_name_with_suffix(name, :facet)
        end

        def self.sort_field_name(name)
          field_name_with_suffix(name, :sort)
        end

        def self.string_field_name(name)
          field_name_with_suffix(name, :string)
        end

        def self.text_field_name(name)
          field_name_with_suffix(name, :text)
        end

        def self.field_name_with_suffix(name, suffix)
          "#{name}_#{SUFFIXES.fetch(suffix)}".to_sym
        end
      end
    end
  end
end

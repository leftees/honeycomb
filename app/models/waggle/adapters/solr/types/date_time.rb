module Waggle
  module Adapters
    module Solr
      module Types
        module DateTime
          SUFFIX = :dt
          XMLSCHEMA = "%Y-%m-%dT%H:%M:%SZ"
          include parent::Base

          def self.as_solr(value)
            if value.is_a?(Array)
              as_solr(value.first)
            else
              if value.is_a?(String)
                value = ::DateTime.parse(value)
              elsif value.respond_to?(:to_datetime)
                value = value.to_datetime
              end
              if value.present?
                if value.respond_to?(:utc)
                  value.utc.strftime(XMLSCHEMA)
                else
                  raise ArgumentError, "Cannot convert #{value.inspect} to a valid datetime format."
                end
              end
            end
          end

          def self.from_solr(value)
            ::DateTime.strptime(value, XMLSCHEMA)
          end
        end
      end
    end
  end
end

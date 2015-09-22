module Waggle
  module Adapters
    module Solr
      module Types
        module DateTime
          SUFFIX = :dt
          XMLSCHEMA = "%Y-%m-%dT%H:%M:%SZ"
          include parent::Base

          def self.value(raw_value)
            if raw_value.is_a?(Array)
              value(raw_value.first)
            else
              if raw_value.is_a?(String)
                raw_value = ::DateTime.parse(raw_value)
              elsif raw_value.respond_to?(:to_datetime)
                raw_value = raw_value.to_datetime
              end
              if raw_value.present?
                if raw_value.respond_to?(:utc)
                  raw_value.utc.strftime(XMLSCHEMA)
                else
                  raise ArgumentError, "Cannot convert #{raw_value.inspect} to a valid datetime format."
                end
              end
            end
          end
        end
      end
    end
  end
end

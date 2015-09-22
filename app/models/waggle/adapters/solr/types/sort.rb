module Waggle
  module Adapters
    module Solr
      module Types
        module Sort
          SUFFIX = :sort
          include parent::Base

          def self.value(value)
            if value.is_a?(Array)
              value.join(" ")
            else
              value
            end
          end
        end
      end
    end
  end
end

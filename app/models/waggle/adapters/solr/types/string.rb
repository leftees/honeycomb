module Waggle
  module Adapters
    module Solr
      module Types
        module String
          SUFFIX = :s
          include parent::Base

          def self.value(value)
            if value.is_a?(Array)
              value.join(" ")
            else
              value.to_s
            end
          end
        end
      end
    end
  end
end

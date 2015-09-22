module Waggle
  module Adapters
    module Solr
      module Types
        module Text
          SUFFIX = :t
          include parent::Base

          def self.as_solr(value)
            if value.is_a?(Array)
              value.map(&:to_s)
            else
              value.to_s
            end
          end
        end
      end
    end
  end
end

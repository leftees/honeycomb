module Waggle
  module Adapters
    module Solr
      module Index
        class Item
          attr_reader :waggle_item
          private :waggle_item

          def initialize(waggle_item:)
            @waggle_item = waggle_item
          end
        end
      end
    end
  end
end

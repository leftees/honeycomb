module Waggle
  module Metadata
    module Value
      class Date < Base
        def value
          fetch("iso8601")
        end
      end
    end
  end
end

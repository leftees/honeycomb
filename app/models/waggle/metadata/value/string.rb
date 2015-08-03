module Waggle
  module Metadata
    module Value
      class String < Base
        def value
          raw_value.to_s
        end
      end
    end
  end
end

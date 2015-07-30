module Waggle
  module Metadata
    module Value
      class String < Base
        def to_s
          value
        end
      end
    end
  end
end

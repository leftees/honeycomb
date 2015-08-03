module Waggle
  module Metadata
    module Value
      class HTML < Base
        def value
          Sanitize.fragment(raw_value.to_s).strip
        end
      end
    end
  end
end

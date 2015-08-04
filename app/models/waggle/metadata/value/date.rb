module Waggle
  module Metadata
    module Value
      class Date < Base
        def value
          @value ||= ::DateTime.iso8601(iso8601)
        end

        private

        def iso8601
          fetch("iso8601")
        end
      end
    end
  end
end

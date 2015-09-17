module Waggle
  module Metadata
    module Value
      class Date < Base
        XMLSCHEMA = "%Y-%m-%dT%H:%M:%SZ"

        def value
          @value ||= ::DateTime.iso8601(iso8601).utc.strftime(XMLSCHEMA)
        end

        private

        def iso8601
          fetch("iso8601")
        end
      end
    end
  end
end

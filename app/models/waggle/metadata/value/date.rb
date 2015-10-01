module Waggle
  module Metadata
    module Value
      class Date < Base
        def value
          puts "value --->"
          puts iso8601
          puts "===="
          @value ||= ::DateTime.iso8601(iso8601).utc
        end

        private

        def iso8601
          fetch("iso8601")
        end
      end
    end
  end
end

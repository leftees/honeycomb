module Waggle
  module Metadata
    module Value
      class Base
        attr_reader :data
        private :data

        def initialize(data)
          @data = data
        end

        def type
          fetch("@type")
        end

        def value
          raise "not implemented"
        end

        def raw_value
          fetch("value")
        end

        private

        def fetch(key)
          data.fetch(key)
        end
      end
    end
  end
end

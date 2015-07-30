module Waggle
  module Metadata
    module Value
      class Base
        attr_reader :data, :type, :value
        private :data

        def initialize(data)
          @type = data.fetch("@type")
          @value = data.fetch("value")
        end
      end
    end
  end
end

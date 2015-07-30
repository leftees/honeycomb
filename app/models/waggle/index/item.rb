module Waggle
  module Index
    module Item
      def self.setup(configuration = default_configuration)
        reset!
        ::Sunspot.setup(Waggle::Item) do
          configuration.fields.each do |field|
            text field.name
          end
          string :type, stored: true
          string :thumbnail_url, stored: true
          time :last_updated, stored: true
          text :name, stored: true
        end
      end

      def self.reset!
        ::Sunspot::Setup.send(:setups)[Waggle::Item.name.to_sym] = nil
      end

      def self.default_configuration
        ::Metadata::Configuration.item_configuration
      end
    end
  end
end

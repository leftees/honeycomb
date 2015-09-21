module Waggle
  module Adapters
    module Solr
      class Session
        attr_reader :config

        def initialize(config = load_configuration)
          @config = config
        end

        def connection
          @connection ||= build_connection
        end

        def index(*objects)
          connection.add(*objects.map(&:as_solr))
        end

        def index!(*objects)
          index(*objects)
          commit
        end

        def commit
          connection.commit
        end

        def remove(*objects)
          connection.delete_by_id(*objects.map(&:index_id))
        end

        def remove!(*objects)
          remove(*objects)
          commit
        end

        private

        def load_configuration
          YAML.load_file(File.join(Rails.root, "config", "solr.yml")).fetch(Rails.env)
        end

        def connection_url
          "http://#{config.fetch('hostname')}:#{config.fetch('port')}#{config.fetch('path')}"
        end

        def build_connection
          ::RSolr.connect(
            url: connection_url,
            read_timeout: config.fetch(:read_timeout, nil),
            open_timeout: config.fetch(:open_timeout, nil),
          )
        end
      end
    end
  end
end

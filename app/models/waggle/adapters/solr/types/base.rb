module Waggle
  module Adapters
    module Solr
      module Types
        module Base
          def self.included(base)
            base.extend(ClassMethods)
          end

          module ClassMethods
            def field_name(name)
              "#{name}_#{self::SUFFIX}".to_sym
            end

            def as_solr(value)
              value
            end

            def from_solr(value)
              value
            end
          end
        end
      end
    end
  end
end

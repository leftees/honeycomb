module CacheKeys
  # Generator handles routing the cache key generation to a given
  # key generator and action for that generator
  class Generator
    attr_reader :generator, :action, :args

    def initialize(key_generator:, action: :generate, **args)
      @generator = key_generator.new
      @action = action
      @args = args
    end

    def generate
      # print generator.class.name + "." + action + "='" + generator.send(action, **@args) + "'\n"
      generator.send(action, **args)
    end
  end
end

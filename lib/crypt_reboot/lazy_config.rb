# frozen_string_literal: true

module CryptReboot
  # Return getter lambdas instead of configuration settings directly
  class LazyConfig
    class << self
      def method_missing(method_name, *args, **kwargs, &block)
        return super unless instance.respond_to?(method_name)

        -> { instance.send(method_name, *args, **kwargs, &block) }
      end

      def respond_to_missing?(name, *_, **_)
        instance.respond_to?(name)
      end

      def instance
        Config.instance
      end
    end
  end
end

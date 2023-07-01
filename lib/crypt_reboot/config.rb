# frozen_string_literal: true

require 'singleton'

module CryptReboot
  # Global configuration singleton
  class Config < InstantiableConfig
    include Singleton

    class << self
      def method_missing(method_name, *args, **kwargs, &block)
        instance.respond_to?(method_name) ? instance.send(method_name, *args, **kwargs, &block) : super
      end

      def respond_to_missing?(name, *_, **_)
        instance.respond_to?(name)
      end
    end
  end
end

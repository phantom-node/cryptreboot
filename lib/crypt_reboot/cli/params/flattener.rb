# frozen_string_literal: true

module CryptReboot
  module Cli
    module Params
      # Replace given key in params with new keys obtained from its contents with suffixes added
      class Flattener
        def call(params)
          paths = params.fetch(key, {}).transform_keys { |k| :"#{k}#{suffix}" }
          params.reject { |k, _| k == key }.merge(paths)
        end

        private

        attr_reader :key, :suffix

        def initialize(key:, suffix:)
          @key = key.to_sym
          @suffix = suffix
        end
      end
    end
  end
end

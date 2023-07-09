# frozen_string_literal: true

module CryptReboot
  module Cli
    module Params
      # Parse given ARGV and return params hash or raise exception with error summary
      class Parser
        ParseError = Class.new StandardError

        def call(raw_params)
          params = definition.parse(raw_params).params
          raise ParseError, params.errors.summary unless params.valid?

          flattener.call params.to_h
        end

        private

        attr_reader :definition, :flattener

        def initialize(definition: Definition.new,
                       flattener: Flattener.new(key: 'paths', suffix: '_path'))
          @definition = definition
          @flattener = flattener
        end
      end
    end
  end
end

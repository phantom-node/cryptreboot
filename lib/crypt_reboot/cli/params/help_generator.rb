# frozen_string_literal: true

module CryptReboot
  module Cli
    module Params
      # Returns usage
      class HelpGenerator
        def call
          definition.help(order: ->(params) { params })
        end

        private

        attr_reader :definition

        def initialize(definition: Definition.new)
          @definition = definition
        end
      end
    end
  end
end

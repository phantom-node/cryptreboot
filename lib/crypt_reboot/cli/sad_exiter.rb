# frozen_string_literal: true

module CryptReboot
  module Cli
    # Exit with error message
    class SadExiter < Exiter
      private

      def initialize(text)
        super(text, status: 1, stream: $stderr)
      end
    end
  end
end

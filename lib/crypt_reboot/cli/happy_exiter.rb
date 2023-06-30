# frozen_string_literal: true

module CryptReboot
  module Cli
    # Exit with a success message
    class HappyExiter < Exiter
      private

      def initialize(text)
        super(text, status: 0, stream: $stdout)
      end
    end
  end
end

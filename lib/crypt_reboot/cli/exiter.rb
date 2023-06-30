# frozen_string_literal: true

module CryptReboot
  module Cli
    # Print a message and return exit status
    class Exiter
      attr_reader :text

      def call
        stream.puts text.strip if text
        status
      end

      private

      attr_reader :status, :stream

      def initialize(text, status:, stream:)
        @text = text
        @status = status
        @stream = stream
      end
    end
  end
end

# frozen_string_literal: true

require 'tty-command'

module CryptReboot
  module Runner
    # Return nil
    class NoResult < Generic
      def call(...)
        super(...)
        nil
      end
    end
  end
end

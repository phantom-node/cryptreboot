# frozen_string_literal: true

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

# frozen_string_literal: true

module CryptReboot
  module Runner
    # Return stdout as string
    class Text < Generic
      def call(...)
        super(...).out
      end
    end
  end
end

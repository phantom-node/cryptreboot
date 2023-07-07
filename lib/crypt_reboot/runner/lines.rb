# frozen_string_literal: true

module CryptReboot
  module Runner
    # Return standard output in form of lines.
    # Newline characters are removed.
    class Lines < Generic
      def call(...)
        super(...).to_a
      end
    end
  end
end

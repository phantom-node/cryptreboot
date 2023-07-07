# frozen_string_literal: true

module CryptReboot
  module Runner
    # Return true or false, depending if command succeeded or failed
    class Boolean < Generic
      def call(...)
        super(...).success?
      end

      private

      def initialize(**opts)
        super(**opts.merge(run_method: :run!))
      end
    end
  end
end

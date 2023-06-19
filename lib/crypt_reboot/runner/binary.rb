# frozen_string_literal: true

require 'tty-command'

module CryptReboot
  module Runner
    # Return stdout as string
    class Binary < Generic
      def call(*args, **opts)
        super(*args, **opts.merge(binary: true)).out
      end
    end
  end
end

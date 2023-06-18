# frozen_string_literal: true

module CryptReboot
  module Luks
    # Return true in case given device is LUKS (of given version is provided), false otherwise
    class Checker
      def call(headevice, version = :any)
        args = version == :any ? [] : ['--type', version]
        runner.call(binary, 'isLuks', 'none', '--header', headevice, *args)
      end

      private

      attr_reader :binary, :runner

      def initialize(binary: '/usr/sbin/cryptsetup',
                     runner: Runner::Boolean.new)
        @binary = binary
        @runner = runner
      end
    end
  end
end

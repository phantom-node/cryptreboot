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

      def binary
        lazy_binary.call
      end

      attr_reader :lazy_binary, :runner

      def initialize(lazy_binary: LazyConfig.cryptsetup_path,
                     runner: Runner::Boolean.new)
        @lazy_binary = lazy_binary
        @runner = runner
      end
    end
  end
end

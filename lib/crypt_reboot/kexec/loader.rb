# frozen_string_literal: true

module CryptReboot
  module Kexec
    # Load new kernel and initramfs into memory, making then ready for later execution
    class Loader
      def call(kernel, cmdline, initramfs)
        runner.call(tool, '-al', kernel, '--append', cmdline, '--initrd', initramfs)
      end

      private

      attr_reader :tool, :runner

      def initialize(tool: '/usr/sbin/kexec',
                     runner: Runner::NoResult.new)
        @tool = tool
        @runner = runner
      end
    end
  end
end

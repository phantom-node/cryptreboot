# frozen_string_literal: true

module CryptReboot
  module Kexec
    # Load new kernel and initramfs into memory, making then ready for later execution
    class Loader
      Error = Class.new StandardError

      def call(kernel, cmdline, initramfs)
        runner.call(tool, '-al', kernel, '--append', cmdline, '--initrd', initramfs)
      rescue exception_class => e
        raise Error, cause: e
      end

      private

      attr_reader :tool, :runner, :exception_class

      def initialize(tool: '/usr/sbin/kexec',
                     runner: Runner::NoResult.new,
                     exception_class: Runner::ExitError)
        @tool = tool
        @runner = runner
        @exception_class = exception_class
      end
    end
  end
end

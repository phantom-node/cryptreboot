# frozen_string_literal: true

module CryptReboot
  module Kexec
    # Load new kernel and initramfs into memory, making then ready for later execution
    class Loader
      def call(boot_config)
        args = [tool, '-al', boot_config.kernel]
        args += ['--initrd', boot_config.initramfs] if boot_config.initramfs
        args += boot_config.cmdline ? ['--append', boot_config.cmdline] : ['--reuse-cmdline']

        runner.call(*args)
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

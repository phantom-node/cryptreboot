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

      def tool
        lazy_tool.call
      end

      attr_reader :lazy_tool, :runner

      def initialize(lazy_tool: LazyConfig.kexec_path,
                     runner: Runner::NoResult.new)
        @lazy_tool = lazy_tool
        @runner = runner
      end
    end
  end
end

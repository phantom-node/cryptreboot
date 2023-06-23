# frozen_string_literal: false

module CryptReboot
  # Data required for booting
  class BootConfig
    attr_reader :kernel, :initramfs, :cmdline

    def ==(other)
      kernel == other.kernel && initramfs == other.initramfs && cmdline == other.cmdline
    end

    def with_initramfs(new_initramfs)
      self.class.new(kernel: kernel, initramfs: new_initramfs, cmdline: cmdline)
    end

    private

    def initialize(kernel:, initramfs: nil, cmdline: nil)
      @kernel = kernel
      @initramfs = initramfs
      @cmdline = cmdline
    end
  end
end

# frozen_string_literal: true

require 'singleton'

module CryptReboot
  # Global configuration
  class Config
    UnrecognizedSetting = Class.new StandardError
    include Singleton

    attr_reader :initramfs, :cmdline, :kernel, :patch_save_path, :cat_path, :cpio_path,
                :unmkinitramfs_path, :kexec_path, :cryptsetup_path, :debug

    def update!(**settings)
      settings.each do |name, value|
        set!(name, value)
      end
    end

    private

    def set!(name, value)
      raise UnrecognizedSetting unless instance_variable_defined?(:"@#{name}")

      instance_variable_set(:"@#{name}", value)
    end

    def initialize
      # Options
      @initramfs = '/boot/initrd.img'
      @cmdline = nil
      @kernel = '/boot/vmlinuz'
      @patch_save_path = nil
      @cat_path = 'cat'
      @cpio_path = 'cpio'
      @unmkinitramfs_path = 'unmkinitramfs'
      @kexec_path = 'kexec'
      @cryptsetup_path = 'cryptsetup'

      # Flags
      @debug = false
    end
  end
end

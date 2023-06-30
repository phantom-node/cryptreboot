# frozen_string_literal: true

module CryptReboot
  # Configuration object
  class InstantiableConfig
    UnrecognizedSetting = Class.new StandardError

    attr_reader :initramfs, :cmdline, :kernel, :patch_save_path, :cat_path, :cpio_path,
                :unmkinitramfs_path, :kexec_path, :cryptsetup_path, :reboot_path,
                :mount_path, :umount_path, :debug, :prepare_only

    def update!(**settings)
      settings.each do |name, value|
        set!(name, value)
      end
    end

    private

    def set!(name, value)
      raise UnrecognizedSetting, "Unrecognized setting `#{name}`" unless instance_variable_defined?(:"@#{name}")

      instance_variable_set(:"@#{name}", value)
    end

    # rubocop:disable Metrics/MethodLength
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
      @reboot_path = 'reboot'
      @mount_path = 'mount'
      @umount_path = 'umount'

      # Flags
      @debug = false
      @prepare_only = false
    end
    # rubocop:enable Metrics/MethodLength
  end
end

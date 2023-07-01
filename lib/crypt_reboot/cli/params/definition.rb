# frozen_string_literal: true

require 'tty-option'

module CryptReboot
  module Cli
    module Params
      # Definition of options, flags, help and other CLI related things
      class Definition
        include TTY::Option
        option :kernel do
          long '--kernel path'
          desc 'Path to the kernel you want to reboot into'
          default Config.kernel
        end

        option :cmdline do
          long '--cmdline string'
          desc 'Command line for loaded kernel; current command line is used if not provided'
        end

        option :initramfs do
          long '--initramfs path'
          desc 'Path to the initramfs to be used by loaded kernel'
          default Config.initramfs
        end

        option :patch_save_path do
          long '--save-patch path'
          desc 'Save initramfs patch to file. WARNING: it contains encryption keys, proceed with caution!'
        end

        # Paths

        option :cat_path do
          long '--cat-path path'
          desc 'Path to `cat` command'
          default Config.cat_path
        end

        option :cpio_path do
          long '--cpio-path path'
          desc 'Path to `cpio` command'
          default Config.cpio_path
        end

        option :unmkinitramfs_path do
          long '--unmkinitramfs-path path'
          desc 'Path to `unmkinitramfs` command'
          default Config.unmkinitramfs_path
        end

        option :kexec_path do
          long '--kexec-path path'
          desc 'Path to `kexec` command'
          default Config.kexec_path
        end

        option :cryptsetup_path do
          long '--cryptsetup-path path'
          desc 'Path to `cryptsetup` command'
          default Config.cryptsetup_path
        end

        option :reboot_path do
          long '--reboot-path path'
          desc 'Path to `reboot` command'
          default Config.cryptsetup_path
        end

        option :mount_path do
          long '--mount-path path'
          desc 'Path to `mount` command'
          default Config.mount_path
        end

        option :umount_path do
          long '--umount-path path'
          desc 'Path to `umount` command'
          default Config.umount_path
        end

        # Flags

        flag :prepare_only do
          short '-p'
          long '--prepare-only'
          desc 'Load kernel and initramfs, but do not reboot'
        end

        flag :debug do
          short '-d'
          long '--debug'
          desc 'Print debug messages'
        end

        flag :version do
          short '-v'
          long '--version'
          desc 'Print version'
        end

        flag :help do
          short '-h'
          long '--help'
          desc 'Print usage'
        end
      end

      # This class contains code from external source,
      # do not expose it anywhere outside of the module
      private_constant :Definition
    end
  end
end

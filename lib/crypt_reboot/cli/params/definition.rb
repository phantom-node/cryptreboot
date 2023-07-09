# frozen_string_literal: true

require 'tty-option'

module CryptReboot
  module Cli
    module Params
      # Definition of options, flags, help and other CLI related things
      # rubocop:disable Metrics/ClassLength
      class Definition
        include TTY::Option

        # rubocop:disable Metrics/BlockLength
        usage do
          header 'Reboot for Linux systems with encrypted root partition.'

          program PROGRAM_NAME
          no_command

          desc 'It asks for a password and reboots the system afterward, automatically unlocking ' \
               'the drive on startup using in-memory initramfs patching and kexec. ' \
               'Without explicit consent, no secrets are stored on disk, even temporarily.',
               '',
               'Useful when unlocking the drive at startup is difficult, such as on headless and remote systems.',
               '',
               "By default, it uses the current kernel command line, \"#{Config.kernel}\" as " \
               "kernel and \"#{Config.initramfs}\" as initramfs.",
               '',
               'It performs operations normally only available to the root user, so it is suggested to use ' \
               'sudo or a similar utility.'

          example 'Normal usage:',
                  "$ sudo #{PROGRAM_NAME}"
          example 'Reboot into custom kernel:',
                  "$ sudo #{PROGRAM_NAME} --kernel /boot/vmlinuz.old --initramfs /boot/initrd.old"
          example 'Specify custom kernel options:',
                  "$ sudo #{PROGRAM_NAME} --cmdline \"root=UUID=d0...a2 ro nomodeset acpi=off\""
          example 'Prepare to reboot and perform it manually later:',
                  "$ sudo #{PROGRAM_NAME} --prepare-only",
                  '$ sleep 3600 # do anything else in-between',
                  '$ sudo reboot --no-wall --no-wtmp'

          footer 'To report a bug, get support or contribute, please visit the project page:',
                 'https://phantomno.de/cryptreboot',
                 '',
                 "Thank you for using #{PROGRAM_NAME}. Happy rebooting!"
        end
        # rubocop:enable Metrics/BlockLength

        option :kernel do
          long '--kernel path'
          desc 'Path to the kernel you want to reboot into'
          default Config.kernel
        end

        option :initramfs do
          long '--initramfs path'
          desc 'Path to the initramfs to be used by loaded kernel'
          default Config.initramfs
        end

        option :cmdline do
          long '--cmdline string'
          desc 'Command line for loaded kernel; current command line is used if not provided'
        end

        # Paths

        option :cat_path do
          long '--cat-path path'
          desc 'Path to "cat" command'
          default Config.cat_path
        end

        option :cpio_path do
          long '--cpio-path path'
          desc 'Path to "cpio" command'
          default Config.cpio_path
        end

        option :cryptsetup_path do
          long '--cryptsetup-path path'
          desc 'Path to "cryptsetup" command'
          default Config.cryptsetup_path
        end

        option :grep_path do
          long '--grep-path path'
          desc 'Path to "grep" command'
          default Config.grep_path
        end

        option :kexec_path do
          long '--kexec-path path'
          desc 'Path to "kexec" command'
          default Config.kexec_path
        end

        option :mount_path do
          long '--mount-path path'
          desc 'Path to "mount" command'
          default Config.mount_path
        end

        option :reboot_path do
          long '--reboot-path path'
          desc 'Path to "reboot" command'
          default Config.reboot_path
        end

        option :strace_path do
          long '--strace-path path'
          desc 'Path to "strace" command, which is used for LZ4 usage detection'
          default Config.strace_path
        end

        option :umount_path do
          long '--umount-path path'
          desc 'Path to "umount" command'
          default Config.umount_path
        end

        option :unmkinitramfs_path do
          long '--unmkinitramfs-path path'
          desc 'Path to "unmkinitramfs" command'
          default Config.unmkinitramfs_path
        end

        # Flags

        flag :skip_lz4_check do
          long '--skip-lz4-check'
          desc 'Do not check if initramfs is compressed with LZ4 algorithm. ' \
               'If you use different compression, it will make initramfs ' \
               'extraction much quicker. But if your initramfs use LZ4 you risk ' \
               'you will need to manually unlock your disk at startup. ' \
               'See the README file to learn how to change the compression ' \
               'algorithm to a more robust one.'
        end

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

        option :patch_save_path do
          long '--save-patch path'
          desc 'Save initramfs patch to file for debug purposes. ' \
               'WARNING: it contains encryption keys, you are responsible for ' \
               'their safe disposal, which may be difficult after the file comes ' \
               'into contact with the disk. Deleting the file alone may not be enough.'
        end

        flag :version do
          short '-v'
          long '--version'
          desc 'Print version and exit'
        end

        flag :help do
          short '-h'
          long '--help'
          desc 'Print this usage and exit'
        end
      end
      # rubocop:enable Metrics/ClassLength

      # This class contains code from external source,
      # do not expose it anywhere outside of the module
      private_constant :Definition
    end
  end
end

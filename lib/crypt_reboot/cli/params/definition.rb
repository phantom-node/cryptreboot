# frozen_string_literal: true

require 'tty-option'

module CryptReboot
  module Cli
    module Params
      # Definition of options, flags, help and other CLI related things
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

        option :paths do
          arity :any
          long '--tool name:path'
          desc 'Path to given external tool specified by "name". By default, tools are searched in the PATH. ' \
               'If you want to specify paths for more than 1 tool, use this option multiple times. Tool names: ' \
               'cat, cpio, cryptsetup, grep, kexec, mount, reboot, strace, umount, unmkinitramfs'
          convert :map
        end

        # Flags

        flag :prepare_only do
          short '-p'
          long '--prepare-only'
          desc 'Load kernel and initramfs, but do not reboot'
        end

        flag :skip_lz4_check do
          long '--skip-lz4-check'
          desc 'Do not check if initramfs is compressed with LZ4 algorithm. ' \
               'If you use different compression and specify this flag, it will make ' \
               'initramfs extraction much faster. But if your initramfs uses ' \
               'LZ4 you risk you will need to manually unlock your disk on startup. ' \
               'See the README file to learn how to change the compression ' \
               'algorithm to a more robust one.'
        end

        flag :insecure_memory do
          short '-s'
          long '--insecure-memory'
          desc 'Do not lock memory. WARNING: there is a risk your secrets will leak to swap.'
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

      # This class contains code from external source,
      # do not expose it anywhere outside of the module
      private_constant :Definition
    end
  end
end

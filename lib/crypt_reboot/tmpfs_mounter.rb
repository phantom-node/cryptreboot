# frozen_string_literal: true

require 'tty-command'

module CryptReboot
  # Mount tmpfs at the given mount point, yield and unmount
  class TmpfsMounter
    def call(dir)
      cmd.run('sudo', '--', 'mount', '-t', 'tmpfs', '-o', 'mode=700', 'none', dir)
      yield
    ensure
      cmd.run('sudo', '--', 'umount', dir)
    end

    private

    attr_reader :cmd

    def initialize(dry_run: false,
                   verbose: false,
                   cmd: TTY::Command.new(
                     dry_run: dry_run,
                     printer: verbose ? :pretty : :null
                   ))
      @cmd = cmd
    end
  end
end

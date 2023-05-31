# frozen_string_literal: true

module CryptReboot
  # Mount tmpfs at the given mount point, yield and unmount
  class TmpfsMounter
    def call(dir)
      runner.call('sudo', '--', 'mount', '-t', 'tmpfs', '-o', 'mode=700', 'none', dir)
      yield
    ensure
      runner.call('sudo', '--', 'umount', dir)
    end

    private

    attr_reader :runner

    def initialize(runner: Runner.new)
      @runner = runner
    end
  end
end

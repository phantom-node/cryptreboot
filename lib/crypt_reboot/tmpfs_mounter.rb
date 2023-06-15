# frozen_string_literal: true

module CryptReboot
  # Mount tmpfs at the given mount point, yield and unmount
  class TmpfsMounter
    Error = Class.new StandardError

    def call(dir, &block)
      mounter.call(dir)
      run(dir, &block)
    rescue exception_class => e
      raise Error, cause: e
    end

    private

    def run(dir, &block)
      block.call
    ensure
      umounter.call(dir)
    end

    attr_reader :runner, :mounter, :umounter, :exception_class

    def initialize(verbose: false,
                   runner: Runner::NoResult.new(verbose: verbose),
                   mounter: ->(dir) { runner.call('mount', '-t', 'tmpfs', '-o', 'mode=700', 'none', dir) },
                   umounter: ->(dir) { runner.call('umount', dir) },
                   exception_class: Runner::ExitError)
      @runner = runner
      @mounter = mounter
      @umounter = umounter
      @exception_class = exception_class
    end
  end
end

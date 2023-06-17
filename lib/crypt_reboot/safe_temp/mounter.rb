# frozen_string_literal: true

module CryptReboot
  module SafeTemp
    # Mount tmpfs at the given mount point, yield and unmount
    class Mounter
      def call(dir, &block)
        mounter.call(dir)
        run(dir, &block)
      end

      private

      def run(dir, &block)
        block.call
      ensure
        umounter.call(dir)
      end

      attr_reader :runner, :mounter, :umounter

      def initialize(verbose: false,
                     runner: Runner::NoResult.new(verbose: verbose),
                     mounter: ->(dir) { runner.call('mount', '-t', 'tmpfs', '-o', 'mode=700', 'none', dir) },
                     umounter: ->(dir) { runner.call('umount', dir) })
        @runner = runner
        @mounter = mounter
        @umounter = umounter
      end
    end
  end
end

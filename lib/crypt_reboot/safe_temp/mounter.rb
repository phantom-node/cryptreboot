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

      def initialize(runner: Runner::NoResult.new,
                     mounter: lambda { |dir|
                                runner.call(Config.mount_path, '-t', 'tmpfs', '-o', 'mode=700', 'none', dir)
                              },
                     umounter: ->(dir) { runner.call(Config.umount_path, dir) })
        @runner = runner
        @mounter = mounter
        @umounter = umounter
      end
    end
  end
end

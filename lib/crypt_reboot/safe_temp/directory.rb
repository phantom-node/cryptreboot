# frozen_string_literal: true

require 'tmpdir'

module CryptReboot
  module SafeTemp
    # Create temporary directory, mounts tmpfs and yields tmp dir location.
    # Make sure to cleanup afterwards.
    class Directory
      def call
        tmp_maker.call do |dir|
          mounter.call(dir) do
            yield dir
          end
        end
      end

      private

      attr_reader :mounter, :tmp_maker

      def initialize(mounter: Mounter.new, tmp_maker: Dir.method(:mktmpdir))
        @mounter = mounter
        @tmp_maker = tmp_maker
      end
    end
  end
end

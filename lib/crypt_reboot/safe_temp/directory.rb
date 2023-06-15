# frozen_string_literal: true

require 'tmpdir'

module CryptReboot
  module SafeTemp
    # Create temporary directory, mounts tmpfs and yields tmp dir location.
    # Make sure to cleanup afterwards.
    class Directory
      def call
        Dir.mktmpdir do |dir|
          mounter.call(dir) do
            yield dir
          end
        end
      end

      private

      attr_reader :mounter

      def initialize(mounter: Mounter.new)
        @mounter = mounter
      end
    end
  end
end

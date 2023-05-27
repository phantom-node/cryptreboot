# frozen_string_literal: true

require 'tmpdir'

module CryptReboot
  # Create temporary directory, mounts tmpfs and yields tmp dir location.
  # Make sure to cleanup afterwards.
  class SafeTempDir
    def call
      Dir.mktmpdir do |dir|
        mounter.call(dir) do
          yield dir
        end
      end
    end

    private

    attr_reader :mounter

    def initialize(mounter: TmpfsMounter.new)
      @mounter = mounter
    end
  end
end

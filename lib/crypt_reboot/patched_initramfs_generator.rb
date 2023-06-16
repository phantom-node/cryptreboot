# frozen_string_literal: true

module CryptReboot
  # Yield path to patched version of provided initramfs
  class PatchedInitramfsGenerator
    def call(initramfs_path, &block)
      patch = squeezer.call(initramfs_path)
      patcher.call(initramfs_path, patch, &block)
    end

    private

    attr_reader :squeezer, :patcher

    def initialize(squeezer: InitramfsPatchSqueezer.new,
                   patcher: Initramfs::Patcher.new)
      @squeezer = squeezer
      @patcher = patcher
    end
  end
end

# frozen_string_literal: true

module CryptReboot
  # Transform initramfs image into a patch (files hash)
  class InitramfsPatchSqueezer
    def call(initramfs_path)
      extractor.call(initramfs_path) do |tmp_dir|
        patchers.inject({}) do |files, patcher|
          files.merge patcher.call(tmp_dir)
        end
      end
    end

    private

    attr_reader :extractor, :patchers

    def initialize(extractor: Initramfs::Extractor.new,
                   patchers: [
                     LuksCryptTabPatcher.new,
                     ZfsKeystorePatcher.new
                   ])
      @extractor = extractor
      @patchers = patchers
    end
  end
end

# frozen_string_literal: true

module CryptReboot
  # Transform initramfs image into a patch (files hash)
  class InitramfsPatchSqueezer
    def call(initramfs_path)
      extractor.call(initramfs_path) do |tmp_dir|
        crypttab_path = File.join(tmp_dir, crypttab_relative_path)
        crypttab_entries = deserializer.call(crypttab_path)
        files_generator.call(crypttab_entries, tmp_dir)
      end
    end

    private

    attr_reader :crypttab_relative_path, :extractor, :deserializer, :files_generator

    def initialize(crypttab_relative_path = 'main/cryptroot/crypttab',
                   extractor: Initramfs::Extractor.new,
                   deserializer: CryptTab::Deserializer.new,
                   files_generator: FilesGenerator.new)
      @crypttab_relative_path = crypttab_relative_path
      @extractor = extractor
      @deserializer = deserializer
      @files_generator = files_generator
    end
  end
end

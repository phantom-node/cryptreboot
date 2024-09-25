# frozen_string_literal: true

module CryptReboot
  # Transform initramfs image into a patch (files hash)
  class InitramfsPatchSqueezer
    def call(initramfs_path)
      extractor.call(initramfs_path) do |tmp_dir|
        full_crypttab_path = File.join(tmp_dir, crypttab_path)
        crypttab_entries = crypttab_deserializer.call(full_crypttab_path)
        files_generator.call(crypttab_entries, base_dir: tmp_dir, crypttab_path: crypttab_path)
      end
    end

    private

    attr_reader :crypttab_path, :extractor, :crypttab_deserializer, :files_generator

    def initialize(crypttab_path = '/cryptroot/crypttab',
                   extractor: Initramfs::Extractor.new,
                   crypttab_deserializer: CryptTab::Deserializer.new,
                   files_generator: FilesGenerator.new)
      @crypttab_path = crypttab_path
      @extractor = extractor
      @crypttab_deserializer = crypttab_deserializer
      @files_generator = files_generator
    end
  end
end

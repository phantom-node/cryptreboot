# frozen_string_literal: true

module CryptReboot
  # Generate patch (files hash) from files in a directory containing uncompressed initramfs
  class LuksCryptTabPatcher
    def call(dir)
      full_crypttab_path = File.join(dir, crypttab_path)
      return {} unless File.exist?(full_crypttab_path)

      crypttab_entries = crypttab_deserializer.call(full_crypttab_path)
      files_generator.call(crypttab_entries, base_dir: dir, crypttab_path: crypttab_path)
    end

    private

    attr_reader :crypttab_path, :crypttab_deserializer, :files_generator

    def initialize(crypttab_path: '/cryptroot/crypttab',
                   crypttab_deserializer: CryptTab::Deserializer.new,
                   files_generator: FilesGenerator.new)
      @crypttab_path = crypttab_path
      @crypttab_deserializer = crypttab_deserializer
      @files_generator = files_generator
    end
  end
end

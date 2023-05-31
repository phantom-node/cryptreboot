# frozen_string_literal: true

module CryptReboot
  # Extracts initramfs and loads crypttab from there
  class CryptTabFromInitramfsLoader
    def call(initramfs)
      extractor.call(initramfs) do |dir|
        crypttab = File.join(dir, crypttab_path)
        loader.call(crypttab)
      end
    end

    private

    attr_reader :crypttab_path, :extractor, :loader

    def initialize(crypttab_path = 'main/cryptroot/crypttab'),
                   extractor: Initramfs::Extractor.new,
                   loader: CryptTab::Loader.new)
      @crypttab_path = crypttab_path
      @extractor = extractor
      @loader = loader
    end
  end
end

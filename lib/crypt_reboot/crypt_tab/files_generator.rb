# frozen_string_literal: true

module CryptReboot
  module CryptTab
    # Generate a hash with file names as keys and file contents as values
    class FilesGenerator
      def call(entries, base_dir)
        files = {}
        modified_entries = entries.map do |entry|
          data = fetch_luks_data(entry, base_dir)
          keyfile = keyfile_locator.call(entry.target)
          files[keyfile] = data.key
          entry_converter.call(entry, data, keyfile)
        rescue not_luks_exception
          next entry
        end
        files.merge(CRYPTAB_PATH => serializer.call(modified_entries))
      end

      private

      CRYPTAB_PATH = '/cryptroot/crypttab'
      private_constant :CRYPTAB_PATH

      def fetch_luks_data(entry, base_dir)
        headevice = entry.headevice(header_prefix: base_dir)
        luks_data_fetcher.call(headevice)
      end

      attr_reader :keyfile_locator, :entry_converter, :serializer,
                  :luks_data_fetcher, :not_luks_exception

      def initialize(keyfile_locator: KeyfileLocator.new,
                     entry_converter: LuksToPlainConverter.new,
                     serializer: Serializer.new,
                     luks_data_fetcher: Luks::DataFetcher.new,
                     not_luks_exception: Luks::DataFetcher::UnsupportedDevice)
        @keyfile_locator = keyfile_locator
        @entry_converter = entry_converter
        @serializer = serializer
        @luks_data_fetcher = luks_data_fetcher
        @not_luks_exception = not_luks_exception
      end
    end
  end
end

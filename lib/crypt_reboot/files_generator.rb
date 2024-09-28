# frozen_string_literal: true

module CryptReboot
  # Generate a hash with file names as keys and file contents as values
  class FilesGenerator
    def call(entries, base_dir:, crypttab_path:)
      files = {}
      modified_entries = entries.map do |entry|
        next entry unless luks?(entry, base_dir)

        data = fetch_data(entry, base_dir)
        keyfile = keyfile_locator.call(entry.target)
        files[keyfile] = data.key
        entry_converter.call(entry, data, keyfile)
      end
      files.merge(crypttab_path => serializer.call(modified_entries))
    end

    private

    def luks?(entry, base_dir)
      headevice = entry.headevice(header_prefix: base_dir)
      luks_checker.call(headevice)
    end

    def fetch_data(entry, base_dir)
      headevice = entry.headevice(header_prefix: base_dir)
      luks_data_fetcher.call(headevice, entry.target)
    end

    attr_reader :keyfile_locator, :entry_converter, :serializer,
                :luks_data_fetcher, :luks_checker

    def initialize(keyfile_locator: CryptTab::KeyfileLocator.new,
                   entry_converter: CryptTab::LuksToPlainConverter.new,
                   serializer: CryptTab::Serializer.new,
                   luks_data_fetcher: Luks::DataFetcher.new,
                   luks_checker: Luks::Checker.new)
      @keyfile_locator = keyfile_locator
      @entry_converter = entry_converter
      @serializer = serializer
      @luks_data_fetcher = luks_data_fetcher
      @luks_checker = luks_checker
    end
  end
end

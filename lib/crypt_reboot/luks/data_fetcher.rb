# frozen_string_literal: true

module CryptReboot
  module Luks
    # Fetch LUKS data including key (user will be asked for passphrase)
    class DataFetcher
      def call(headevice, target)
        version = detector.call(headevice)
        data = dumper.call(headevice, version)
        pass = asker.call("Please unlock disk #{target}: ")
        key = key_fetcher.call(headevice, pass)
        data.with_key(key)
      end

      private

      attr_reader :detector, :dumper, :asker, :key_fetcher

      def initialize(detector: VersionDetector.new,
                     dumper: Dumper.new,
                     asker: PassphraseAsker.new,
                     key_fetcher: KeyFetcher.new)
        @detector = detector
        @dumper = dumper
        @asker = asker
        @key_fetcher = key_fetcher
      end
    end
  end
end

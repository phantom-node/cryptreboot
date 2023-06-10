# frozen_string_literal: true

module CryptReboot
  module Luks
    # Fetch LUKS data including key (user will be asked for passphrase)
    class DataFetcher
      UnsupportedDevice = Class.new StandardError

      def call(headevice)
        version = detect_version(headevice)
        data = dumper.call(headevice, version)
        pass = asker.call("Enter passphrase to unlock #{headevice}: ")
        key = key_fetcher.call(headevice, pass)
        data.dup_adding_key(key)
      end

      private

      def detect_version(headevice)
        detector.call(headevice)
      rescue unsupported_device_exception => e
        raise UnsupportedDevice, cause: e
      end

      attr_reader :detector, :unsupported_device_exception, :dumper, :asker, :key_fetcher

      def initialize(detector: VersionDetector.new,
                     unsupported_device_exception: VersionDetector::Error,
                     dumper: Dumper.new,
                     asker: PassphraseAsker.new,
                     key_fetcher: KeyFetcher.new)
        @detector = detector
        @unsupported_device_exception = unsupported_device_exception
        @dumper = dumper
        @asker = asker
        @key_fetcher = key_fetcher
      end
    end
  end
end

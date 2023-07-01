# frozen_string_literal: true

module CryptReboot
  module Luks
    # Fetch LUKS key
    class KeyFetcher
      InvalidPassphrase = Class.new StandardError

      def call(headevice, passphrase)
        temp_provider.call do |key_file|
          luks_dump(headevice, key_file, passphrase)
          file_reader.call(key_file)
        end
      end

      private

      def luks_dump(headevice, master_key_file, passphrase)
        runner.call(
          binary, 'luksDump', 'none', '--header', headevice,
          '--dump-master-key', '--master-key-file', master_key_file,
          '--key-file', '-',
          input: passphrase
        )
      rescue run_exception
        # For simplicity sake let's assume it's invalid passphrase.
        # Other errors such as invalid device/header were handled by previous validation.
        raise InvalidPassphrase
      end

      def binary
        lazy_binary.call
      end

      attr_reader :lazy_binary, :runner, :run_exception, :file_reader, :temp_provider

      def initialize(lazy_binary: LazyConfig.cryptsetup_path,
                     runner: Runner::Lines.new,
                     run_exception: Runner::ExitError,
                     file_reader: File.method(:read),
                     temp_provider: SafeTemp::FileName.new)
        @lazy_binary = lazy_binary
        @runner = runner
        @run_exception = run_exception
        @file_reader = file_reader
        @temp_provider = temp_provider
      end
    end
  end
end

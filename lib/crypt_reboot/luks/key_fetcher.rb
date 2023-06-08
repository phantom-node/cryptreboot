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
          'luksDump', headevice,
          '--dump-master-key', '--master-key-file', master_key_file,
          '--key-file', '-',
          input: passphrase
        )
      rescue run_exception
        # For simplicity sake let's assume it's invalid passphrase.
        # Other errors such as invalid device/header were handled by version validation.
        raise InvalidPassphrase
      end

      attr_reader :runner, :run_exception, :file_reader, :temp_provider

      def initialize(verbose: false,
                     runner: CryptSetupRunner.new(verbose: verbose),
                     run_exception: CryptSetupRunner::ExitError,
                     file_reader: File.method(:read),
                     temp_provider: SafeTempFile.new)
        @runner = runner
        @run_exception = run_exception
        @file_reader = file_reader
        @temp_provider = temp_provider
      end
    end
  end
end

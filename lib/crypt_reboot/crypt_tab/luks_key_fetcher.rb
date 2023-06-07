# frozen_string_literal: true

module CryptReboot
  module CryptTab
    # Fetch LUKS key
    class LuksKeyFetcher
      InvalidPassphrase = Class.new StandardError

      def call(header_path, passphrase)
        temp_provider.call do |key_file|
          luks_dump(header_path, key_file, passphrase)
          file_reader.call(key_file)
        end
      end

      private

      def luks_dump(header_path, master_key_file, passphrase)
        runner.call(
          '/usr/sbin/cryptsetup', 'luksDump', 'none',
          '--header', header_path,
          '--dump-master-key', '--master-key-file', master_key_file,
          '--key-file', '-',
          input: passphrase
        )
      rescue run_exception
        # For simplicity sake let's assume it's invalid passphrase.
        # Other errors such as invalid device/header were probably
        # handled in other places.
        raise InvalidPassphrase
      end

      attr_reader :runner, :run_exception, :file_reader, :temp_provider

      def initialize(verbose: false,
                     runner: Runner.new(verbose: verbose),
                     run_exception: Runner::ExitError,
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

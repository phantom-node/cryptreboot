# frozen_string_literal: true

module CryptReboot
  module CryptTab
    # Get a list of keystore zvols from a running system and return entries array
    class ZfsKeystoreEntriesGenerator
      def call
        glob = File.join(zvol_dir, '**/*')
        Dir.glob(glob)
           .select { |path| path =~ %r{/keystore$} && exist?(path) }
           .map { |path| generate_entry(path) }
      end

      private

      def exist?(path)
        File.exist? File.realpath(path)
      end

      def generate_entry(path)
        pool = File.basename File.dirname(path)
        target = "keystore-#{pool}"
        entry_class.new target: target, source: path, key_file: 'none', options: {}, flags: %w[luks discard]
      end

      attr_reader :zvol_dir, :entry_class

      def initialize(zvol_dir: '/dev/zvol', entry_class: Entry)
        @zvol_dir = zvol_dir
        @entry_class = entry_class
      end
    end
  end
end

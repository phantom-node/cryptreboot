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
        # Target name is the same as produced by /scripts/zfs script within initramfs
        entry_builder.call target: "keystore-#{pool}", source: path
      end

      attr_reader :zvol_dir, :entry_builder

      def initialize(zvol_dir: '/dev/zvol',
                     entry_builder: lambda { |target:, source:|
                       # Flags and options are the same as produced by /scripts/zfs script within initramfs
                       Entry.new target: target,
                                 source: source,
                                 key_file: 'none',
                                 options: {},
                                 flags: %i[luks discard]
                     })
        @zvol_dir = zvol_dir
        @entry_builder = entry_builder
      end
    end
  end
end

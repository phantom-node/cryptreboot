# frozen_string_literal: true

module CryptReboot
  module CryptTab
    # Convert given crypttab entry from LUKS to plain mode
    class LuksToPlainConverter
      def call(entry, data, keyfile)
        entry_class.new(
          target: entry.target,
          source: entry.source,
          key_file: keyfile,
          options: convert_options(entry.options, data),
          flags: entry.flags - [:luks] + [:plain]
        )
      end

      private

      # According to cryptsetup manual, offset is specified in 512-byte sectors.
      # Therefore sector size of the actual device shouldn't be used.
      OFFSET_SECTOR_SIZE = 512
      private_constant :OFFSET_SECTOR_SIZE

      def convert_options(options, data)
        options = options.reject do |option, _|
          %i[keyfile-size keyslot key-slot header keyscript].include? option
        end
        options[:'sector-size'] ||= data.sector_size # allow user to set it explicitly
        options.merge({ cipher: data.cipher, size: data.key_bits, offset: data.offset / OFFSET_SECTOR_SIZE })
      end

      attr_reader :entry_class

      def initialize(entry_class: Entry)
        @entry_class = entry_class
      end
    end
  end
end

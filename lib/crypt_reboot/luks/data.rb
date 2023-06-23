# frozen_string_literal: true

module CryptReboot
  module Luks
    # Value-object with encryption parameters
    class Data
      attr_reader :cipher, :offset, :sector_size, :key

      def ==(other)
        cipher == other.cipher && offset == other.offset &&
          sector_size == other.sector_size && key == other.key
      end

      def key_bits
        key.bytesize * 8
      end

      def with_key(new_key)
        self.class.new(
          cipher: cipher,
          offset: offset,
          sector_size: sector_size,
          key: new_key
        )
      end

      private

      def initialize(cipher:, offset:, sector_size:, key: '')
        @cipher = cipher
        @offset = offset
        @sector_size = sector_size
        @key = key
      end
    end
  end
end

# frozen_string_literal: true

module CryptReboot
  module Initramfs
    # Instantiates appropriate decompressor
    class Decompressor
      def call(skip_lz4_check: Config.skip_lz4_check)
        skip_lz4_check ? TolerantDecompressor.new : IntolerantDecompressor.new
      end
    end
  end
end

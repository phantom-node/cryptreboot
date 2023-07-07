# frozen_string_literal: true

module CryptReboot
  module Initramfs
    # Instantiates appropriate decompressor
    class Decompressor
      def call(allow_lz4: Config.allow_lz4)
        allow_lz4 ? TolerantDecompressor.new : IntolerantDecompressor.new
      end
    end
  end
end

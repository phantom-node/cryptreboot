# frozen_string_literal: true

require 'tmpdir'

module CryptReboot
  module Initramfs
    # Create temporary directory, extract initramfs there and yield, cleaning afterwards
    class Extractor
      def call(filename)
        tmp_maker.call do |dir|
          logger.call message
          decompressor.call(filename, dir)
          yield dir
        end
      end

      private

      def decompressor
        decompressor_factory.call
      end

      attr_reader :tmp_maker, :decompressor_factory, :message, :logger

      def initialize(tmp_maker: Dir.method(:mktmpdir),
                     decompressor_factory: Decompressor.new,
                     message: 'Extracting initramfs... (in future versions it will run faster)',
                     logger: ->(msg) { warn msg })
        @tmp_maker = tmp_maker
        @decompressor_factory = decompressor_factory
        @message = message
        @logger = logger
      end
    end
  end
end

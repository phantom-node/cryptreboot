# frozen_string_literal: true

require 'tmpdir'

module CryptReboot
  module Initramfs
    # Create temporary directory, extract initramfs there and yield, cleaning afterwards
    class Extractor
      def call(filename)
        tmp_maker.call do |dir|
          runner.call(tool, filename, dir)
          yield dir
        end
      end

      private

      attr_reader :lazy_tool, :tmp_maker, :runner

      def tool
        lazy_tool.call
      end

      def initialize(lazy_tool: LazyConfig.unmkinitramfs_path,
                     tmp_maker: Dir.method(:mktmpdir),
                     runner: Runner::NoResult.new)
        @lazy_tool = lazy_tool
        @tmp_maker = tmp_maker
        @runner = runner
      end
    end
  end
end

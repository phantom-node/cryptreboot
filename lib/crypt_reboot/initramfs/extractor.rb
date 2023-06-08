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

      attr_reader :tool, :tmp_maker, :runner

      def initialize(tool: '/usr/bin/unmkinitramfs',
                     tmp_maker: Dir.method(:mktmpdir),
                     runner: SimpleRunner.new)
        @tool = tool
        @tmp_maker = tmp_maker
        @runner = runner
      end
    end
  end
end

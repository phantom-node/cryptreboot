# frozen_string_literal: true

require 'find'

module CryptReboot
  module Initramfs
    # Create compressed CPIO archive from files in a given directory
    class Archiver
      def call(dir, archive)
        Dir.chdir(dir) do
          uncompressed = runner.call(cpio, '-oH', 'newc', '--reproducible', input: finder.call)
          gziper.call(archive, uncompressed)
        end
      end

      private

      def cpio
        lazy_cpio.call
      end

      attr_reader :runner, :finder, :lazy_cpio, :gziper

      def initialize(runner: Runner::Binary.new,
                     finder: -> { Find.find('.').to_a.join("\n") },
                     lazy_cpio: LazyConfig.cpio_path,
                     gziper: Gziper.new)
        @runner = runner
        @finder = finder
        @lazy_cpio = lazy_cpio
        @gziper = gziper
      end
    end
  end
end

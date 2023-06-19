# frozen_string_literal: false

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

      attr_reader :runner, :finder, :cpio, :gziper

      def initialize(runner: Runner::Binary.new,
                     finder: -> { Find.find('.').to_a.join("\n") },
                     cpio: '/usr/bin/cpio',
                     gziper: Gziper.new)
        @runner = runner
        @finder = finder
        @cpio = cpio
        @gziper = gziper
      end
    end
  end
end

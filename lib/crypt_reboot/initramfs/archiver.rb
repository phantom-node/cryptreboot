# frozen_string_literal: false

require 'find'

module CryptReboot
  module Initramfs
    # Create compressed CPIO archive from files in a given directory
    class Archiver
      def call(dir, archive)
        Dir.chdir(dir) do
          runner.call(cpio, '-oH', 'newc', '--reproducible', input: finder.call, output_file: archive)
        end
      end

      private

      attr_reader :runner, :finder, :cpio

      def initialize(runner: Runner::NoResult.new,
                     finder: -> { Find.find('.').to_a.join("\n") },
                     cpio: '/usr/bin/cpio')
        @runner = runner
        @finder = finder
        @cpio = cpio
      end
    end
  end
end

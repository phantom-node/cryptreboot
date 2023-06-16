# frozen_string_literal: false

require 'find'

module CryptReboot
  module Initramfs
    # Create compressed CPIO archive from files in a given directory
    class Archiver
      Error = Class.new StandardError

      def call(dir, archive)
        Dir.chdir(dir) do
          runner.call(cpio, '-oH', 'newc', '--reproducible', input: finder.call, output_file: archive)
        rescue exception_class => e
          raise Error, cause: e
        end
      end

      private

      attr_reader :runner, :exception_class, :finder, :cpio

      def initialize(runner: Runner::NoResult.new,
                     exception_class: Runner::ExitError,
                     finder: -> { Find.find('.').to_a.join("\n") },
                     cpio: '/usr/bin/cpio')
        @runner = runner
        @exception_class = exception_class
        @finder = finder
        @cpio = cpio
      end
    end
  end
end

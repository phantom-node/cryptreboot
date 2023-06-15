# frozen_string_literal: true

require 'tmpdir'

module CryptReboot
  module Initramfs
    # Create temporary directory, extract initramfs there and yield, cleaning afterwards
    class Extractor
      Error = Class.new StandardError

      def call(filename)
        tmp_maker.call do |dir|
          run(tool, filename, dir)
          yield dir
        end
      end

      private

      def run(*args)
        runner.call(*args)
      rescue exception_class => e
        raise Error, cause: e
      end

      attr_reader :tool, :tmp_maker, :runner, :exception_class

      def initialize(tool: '/usr/bin/unmkinitramfs',
                     tmp_maker: Dir.method(:mktmpdir),
                     runner: Runner::NoResult.new,
                     exception_class: Runner::ExitError)
        @tool = tool
        @tmp_maker = tmp_maker
        @runner = runner
        @exception_class = exception_class
      end
    end
  end
end

# frozen_string_literal: true

module CryptReboot
  module Luks
    # Depending on LUKS version, delegates parsing to different parser
    class Dumper
      def call(headevice, version)
        dump = runner.call('luksDump', headevice)
        parser = parsers.fetch(version)
        parser.call(dump)
      end

      private

      attr_reader :runner, :parsers

      def initialize(runner: CryptSetupRunner.new,
                     parsers: { 'LUKS2' => LuksV2Parser.new, 'LUKS1' => LuksV1Parser.new })
        @runner = runner
        @parsers = parsers
      end
    end
  end
end

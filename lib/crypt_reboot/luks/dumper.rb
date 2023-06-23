# frozen_string_literal: true

module CryptReboot
  module Luks
    # Depending on LUKS version, delegates parsing to different parser
    class Dumper
      def call(headevice, version)
        dump = runner.call(binary, 'luksDump', 'none', '--header', headevice)
        parser = parsers.fetch(version)
        parser.call(dump)
      end

      private

      attr_reader :binary, :runner, :parsers

      def initialize(binary: Config.instance.cryptsetup_path,
                     runner: Runner::Lines.new,
                     parsers: { 'LUKS2' => LuksV2Parser.new, 'LUKS1' => LuksV1Parser.new })
        @binary = binary
        @runner = runner
        @parsers = parsers
      end
    end
  end
end

# frozen_string_literal: true

require 'tty-command'

module CryptReboot
  module Luks
    # Run cryptsetup and return standard output as an array of lines.
    # To specify string to be passed as standard input, use input option.
    class CryptSetupRunner
      ExitError = Class.new StandardError

      def call(command, headevice, *options, input: nil)
        run_options = input ? { input: input } : {}
        runner.call(binary, command, 'none', '--header', headevice, *options, **run_options)
      rescue runner_exception
        raise ExitError
      end

      private

      attr_reader :runner, :runner_exception, :binary

      def initialize(verbose: false,
                     runner: ->(*a, **b) { TTY::Command.new(printer: verbose ? :pretty : :null).run(*a, **b).to_a },
                     runner_exception: TTY::Command::ExitError,
                     binary: '/usr/sbin/cryptsetup')
        @runner = runner
        @runner_exception = runner_exception
        @binary = binary
      end
    end
  end
end

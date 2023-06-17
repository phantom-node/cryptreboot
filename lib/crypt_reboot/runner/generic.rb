# frozen_string_literal: true

require 'tty-command'

module CryptReboot
  module Runner
    # Run an external process. Abstract class, use descendants.
    class Generic
      private

      def call(*args, input: nil, output_file: nil)
        options = build_options(input, output_file)
        adjusted_args = front_args + args
        cmd.send(run_method, *adjusted_args, **options)
      rescue cmd_exception => e
        raise ExitError, cause: e
      end

      def build_options(input, output_file)
        {}.tap do |options|
          options[:input] = input if input
          options[:out] = output_file if output_file
        end
      end

      attr_reader :cmd, :run_method, :front_args, :cmd_exception

      def initialize(verbose: false,
                     cmd: TTY::Command.new(printer: verbose ? :pretty : :null),
                     run_method: :run,
                     sudo: false,
                     cmd_exception: TTY::Command::ExitError)
        @cmd = cmd
        @run_method = run_method
        @front_args = sudo ? ['sudo', '--'] : []
        @cmd_exception = cmd_exception
      end
    end
  end
end

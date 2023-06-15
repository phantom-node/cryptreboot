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
        cmd.run(*adjusted_args, **options)
      rescue TTY::Command::ExitError => e
        raise exception_class, cause: e
      end

      def build_options(input, output_file)
        {}.tap do |options|
          options[:input] = input if input
          options[:out] = output_file if output_file
        end
      end

      attr_reader :cmd, :front_args, :exception_class

      def initialize(verbose: false,
                     cmd: TTY::Command.new(printer: verbose ? :pretty : :null),
                     sudo: false,
                     exception_class: ExitError)
        @cmd = cmd
        @front_args = sudo ? ['sudo', '--'] : []
        @exception_class = exception_class
      end
    end
  end
end

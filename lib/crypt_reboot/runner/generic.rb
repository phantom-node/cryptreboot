# frozen_string_literal: true

require 'tty-command'

module CryptReboot
  module Runner
    # Run an external process. Abstract class, use descendants.
    class Generic
      private

      def call(*args, input: nil, output_file: nil, binary: false)
        options = build_options(input, output_file, binary)
        adjusted_args = front_args + args
        cmd.send(run_method, *adjusted_args, **options)
      rescue exceptions[:exit] => e
        raise ExitError, cause: e
      rescue exceptions[:not_found] => e
        raise CommandNotFound, cause: e
      end

      def build_options(input, output_file, binary)
        {}.tap do |options|
          options[:input] = input if input
          options[:out] = output_file if output_file
          options[:binmode] = true if binary
        end
      end

      attr_reader :cmd, :run_method, :front_args, :exceptions

      def initialize(cmd: TTY::Command.new(printer: Config.instance.verbose ? :pretty : :null),
                     run_method: :run,
                     sudo: false,
                     exceptions: {
                       exit: TTY::Command::ExitError,
                       not_found: Errno::ENOENT
                     })
        @cmd = cmd
        @run_method = run_method
        @front_args = sudo ? ['sudo', '--'] : []
        @exceptions = exceptions
      end
    end
  end
end

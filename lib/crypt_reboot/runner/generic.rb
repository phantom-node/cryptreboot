# frozen_string_literal: true

require 'tty-command'

module CryptReboot
  module Runner
    # Run an external process. Abstract class, use descendants.
    class Generic
      private

      def call(*args, input: nil, output_file: nil, binary: false)
        options = build_options(input, output_file, binary)
        cmd.send(run_method, *args, **options)
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

      def cmd
        lazy_cmd.call
      end

      attr_reader :lazy_cmd, :run_method, :exceptions

      def initialize(lazy_cmd: -> { TTY::Command.new(uuid: false, printer: Config.debug ? :pretty : :null) },
                     run_method: :run,
                     exceptions: {
                       exit: TTY::Command::ExitError,
                       not_found: Errno::ENOENT
                     })
        @lazy_cmd = lazy_cmd
        @run_method = run_method
        @exceptions = exceptions
      end
    end
  end
end

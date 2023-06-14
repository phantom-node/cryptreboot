# frozen_string_literal: true

require 'tty-command'

module CryptReboot
  # Run an external process and return stdout. Stderr is ignored.
  class SimpleRunner
    ExitError = Class.new StandardError

    def call(*args)
      cmd.run(*args).out
    rescue TTY::Command::ExitError => e
      raise exception_class, cause: e
    end

    private

    attr_reader :cmd, :exception_class

    def initialize(verbose: false,
                   cmd: TTY::Command.new(printer: verbose ? :pretty : :null),
                   exception_class: ExitError)
      @cmd = cmd
      @exception_class = exception_class
    end
  end
end

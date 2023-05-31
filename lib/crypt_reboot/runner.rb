# frozen_string_literal: true

require 'tty-command'

module CryptReboot
  # Run an external process and return stdout/stderr
  class Runner
    ExitError = Class.new StandardError

    def call(...)
      cmd.run(...)
    rescue TTY::Command::ExitError
      raise ExitError
    end

    private

    attr_reader :cmd

    def initialize(verbose: false, cmd: TTY::Command.new(printer: verbose ? :pretty : :null))
      @cmd = cmd
    end
  end
end

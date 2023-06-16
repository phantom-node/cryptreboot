# frozen_string_literal: true

module CryptReboot
  # Concatenate files into one
  class Concatenator
    Error = Class.new StandardError

    def call(*files, to:)
      runner.call(tool, *files, output_file: to)
    rescue exception_class => e
      raise Error, cause: e
    end

    private

    attr_reader :tool, :runner, :exception_class

    def initialize(tool: '/usr/bin/cat',
                   verbose: false,
                   runner: Runner::NoResult.new(verbose: verbose),
                   exception_class: Runner::ExitError)
      @tool = tool
      @runner = runner
      @exception_class = exception_class
    end
  end
end

# frozen_string_literal: true

module CryptReboot
  # Concatenate files into one
  class Concatenator
    def call(*files, to:)
      runner.call(tool, *files, output_file: to)
    end

    private

    attr_reader :tool, :runner

    def initialize(tool: '/usr/bin/cat',
                   verbose: false,
                   runner: Runner::NoResult.new(verbose: verbose))
      @tool = tool
      @runner = runner
    end
  end
end

# frozen_string_literal: true

module CryptReboot
  # Concatenate files into one
  class Concatenator
    def call(*files, to:)
      runner.call(tool, *files, output_file: to)
    end

    private

    attr_reader :tool, :runner

    def initialize(tool: Config.instance.cat_path,
                   runner: Runner::NoResult.new)
      @tool = tool
      @runner = runner
    end
  end
end

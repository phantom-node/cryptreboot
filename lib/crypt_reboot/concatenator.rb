# frozen_string_literal: true

module CryptReboot
  # Concatenate files into one
  class Concatenator
    def call(*files, to:)
      runner.call(tool, *files, output_file: to)
    end

    private

    def tool
      lazy_tool.call
    end

    attr_reader :lazy_tool, :runner

    def initialize(lazy_tool: LazyConfig.cat_path,
                   runner: Runner::NoResult.new)
      @lazy_tool = lazy_tool
      @runner = runner
    end
  end
end

# frozen_string_literal: true

require 'fileutils'

module CryptReboot
  # Copy given file to specified dir if specified, otherwise do nothing
  class FileSaver
    def call(file)
      FileUtils.cp(file, dir) if dir
    end

    private

    attr_reader :dir

    def initialize(dir)
      @dir = dir
    end
  end
end

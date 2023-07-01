# frozen_string_literal: true

require 'zlib'

module CryptReboot
  # Gzip data and save it to file
  class Gziper
    def call(archive_path, data)
      writer.call(archive_path) do |gz|
        gz.write data
      end
    end

    private

    attr_reader :writer

    def initialize(writer: Zlib::GzipWriter.method(:open))
      @writer = writer
    end
  end
end

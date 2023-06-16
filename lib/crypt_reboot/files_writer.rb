# frozen_string_literal: true

require 'fileutils'

module CryptReboot
  # Writes files from hash to specified directory
  class FilesWriter
    def call(files, target_dir)
      files.each do |relative_path, content|
        path = File.join(target_dir, relative_path)
        dir = File.dirname(path)
        FileUtils.mkdir_p(dir) unless File.directory?(dir)
        File.binwrite(path, content)
      end
    end
  end
end

# frozen_string_literal: true

require 'fileutils'

module CryptReboot
  module Initramfs
    # Yield path to initramfs patched with files_spec.
    # Patched initramfs will be removed afterwards if user doesn't want to save it
    class Patcher
      def call(initramfs_path, files_spec)
        temp_provider.call do |base_dir|
          files_dir, patch_path, patched_path = prefix('files', 'patch', 'result', with: base_dir)
          writer.call(files_spec, files_dir)
          archiver.call(files_dir, patch_path)
          saver.call(patch_path)
          concatenator.call(initramfs_path, patch_path, to: patched_path)
          yield patched_path
        end
      end

      private

      def prefix(*file_names, with:)
        file_names.map do |file_name|
          File.join(with, file_name)
        end
      end

      attr_reader :temp_provider, :writer, :archiver, :concatenator, :saver

      def initialize(temp_provider: SafeTemp::Directory.new,
                     writer: FilesWriter.new,
                     archiver: Archiver.new,
                     concatenator: Concatenator.new,
                     saver: lambda { |file|
                              dir = Config.patch_save_path
                              FileUtils.cp(file, dir) if dir
                            })
        @temp_provider = temp_provider
        @writer = writer
        @archiver = archiver
        @concatenator = concatenator
        @saver = saver
      end
    end
  end
end

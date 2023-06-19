# frozen_string_literal: true

require 'tmpdir'

module CryptReboot
  module Initramfs
    RSpec.describe Archiver do
      subject(:archiver) { described_class.new(gziper: File.method(:binwrite)) }

      let(:files_dir) { 'spec/fixtures/archiver/files' }

      def tmp_file
        Dir.mktmpdir do |base_dir|
          file = File.join(base_dir, 'file')
          yield file
        end
      end

      it 'produces archive with valid header' do
        tmp_file do |archive_path|
          archiver.call(files_dir, archive_path)
          archive = File.read(archive_path)
          expect(archive).to start_with('070701')
        end
      end

      it 'produces archive containing file' do
        tmp_file do |archive_path|
          archiver.call(files_dir, archive_path)
          archive = File.read(archive_path)
          expect(archive).to match(/file1.txt.+testfile1/)
        end
      end

      it 'produces archive with valid trailer' do
        tmp_file do |archive_path|
          archiver.call(files_dir, archive_path)
          archive = File.read(archive_path)
          expect(archive).to match(/TRAILER!!!/)
        end
      end
    end
  end
end

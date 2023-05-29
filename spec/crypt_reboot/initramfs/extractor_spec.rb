# frozen_string_literal: true

module CryptReboot
  module Initramfs
    RSpec.describe Extractor do
      subject(:extractor) { described_class.new(runner: fake_runner) }

      def test_file_path(dir)
        File.join(dir, 'test_file.txt')
      end

      let :fake_runner do
        ->(_tool, _initramfs, dir) { File.open(test_file_path(dir), 'w') { 0 } }
      end

      it 'extracts' do
        extractor.call('dummy_initramfs') do |dir|
          expect(File).to exist(test_file_path(dir))
        end
      end

      it 'cleans up' do
        tmp_dir = nil
        extractor.call('dummy_initramfs') do |dir|
          tmp_dir = dir
        end
        expect(File).not_to exist(tmp_dir)
      end
    end
  end
end

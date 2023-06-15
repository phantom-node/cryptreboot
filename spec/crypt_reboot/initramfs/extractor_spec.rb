# frozen_string_literal: true

module CryptReboot
  module Initramfs
    RSpec.describe Extractor do
      subject(:extractor) { described_class.new(runner: fake_runner, exception_class: exception_class) }

      let(:exception_class) { ZeroDivisionError }

      let :fake_runner do
        ->(_tool, _initramfs, dir) { File.open(test_file_path(dir), 'w') { 0 } }
      end

      def test_file_path(dir)
        File.join(dir, 'test_file.txt')
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

      context 'when exception happens' do
        let :fake_runner do
          proc { raise exception_class }
        end

        it 're-raises the exception' do
          expect do
            extractor.call('dummy_initramfs') {}
          end.to raise_error(Extractor::Error)
        end
      end
    end
  end
end

# frozen_string_literal: true

module CryptReboot
  module Initramfs
    RSpec.describe Extractor do
      subject(:extractor) do
        described_class.new(decompressor_factory: -> { fake_decompressor },
                            logger: logger,
                            message: 'extracting')
      end

      let(:logger) { spy }

      let :fake_decompressor do
        ->(_initramfs, dir) { File.open(test_file_path(dir), 'w') { 0 } }
      end

      def test_file_path(dir)
        File.join(dir, 'test_file.txt')
      end

      it 'extracts' do
        extractor.call('dummy_initramfs') do |dir|
          expect(File).to exist(test_file_path(dir))
        end
      end

      it 'displays message' do
        extractor.call('dummy_initramfs') {}
        expect(logger).to have_received(:call).with('extracting')
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

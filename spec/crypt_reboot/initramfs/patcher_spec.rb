# frozen_string_literal: true

require 'tmpdir'

module CryptReboot
  module Initramfs
    RSpec.describe Patcher do
      subject(:patcher) do
        described_class.new(
          temp_provider: Dir.method(:mktmpdir),
          archiver: ->(dir, file) { `cd #{dir}; find > #{file}` }
        )
      end

      let(:initramfs_path) { 'spec/fixtures/dummy_initramfs' }

      let(:files_spec) do
        { 'file1' => 'contents1', 'dir1/file2' => 'contents2' }
      end

      let(:expected_initramfs) do
        "not real\n.\n./file1\n./dir1\n./dir1/file2\n"
      end

      it 'yields a block' do
        expect do |block|
          patcher.call(initramfs_path, files_spec, &block)
        end.to yield_control
      end

      it 'patches initramfs' do
        patched = nil
        patcher.call(initramfs_path, files_spec) { |path| patched = File.read(path) }
        expect(patched).to eq(expected_initramfs)
      end

      it 'cleans up' do
        patched_path = nil
        patcher.call(initramfs_path, files_spec) { |path| patched_path = path }
        expect(File).not_to exist(patched_path)
      end
    end
  end
end

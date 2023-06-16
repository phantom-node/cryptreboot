# frozen_string_literal: true

module CryptReboot
  RSpec.describe PatchedInitramfsGenerator do
    subject(:generator) do
      described_class.new(
        squeezer: ->(_) { { 'file' => 'content' } },
        patcher: ->(image, patch, &block) { block.call("#{image} was patched with #{patch}") }
      )
    end

    let(:expected_path) { 'my_initramfs_image was patched with {"file"=>"content"}' }

    it 'yields something' do
      expect do |block|
        generator.call('my_initramfs_image', &block)
      end.to yield_control
    end

    it 'yields patched initramfs' do
      generator.call('my_initramfs_image') do |path|
        expect(path).to eq(expected_path)
      end
    end
  end
end

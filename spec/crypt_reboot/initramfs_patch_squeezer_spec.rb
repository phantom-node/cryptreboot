# frozen_string_literal: true

module CryptReboot
  RSpec.describe InitramfsPatchSqueezer do
    subject(:squeezer) do
      described_class.new(
        extractor: ->(_, &b) { b.call('dir_with_unpacked_initramfs') },
        patchers: [
          ->(_) { { 'file1' => 'content1' } },
          ->(_) { { 'file2' => 'content2' } }
        ]
      )
    end

    let :expected_patch do
      {
        'file1' => 'content1',
        'file2' => 'content2'
      }
    end

    it do
      patch = squeezer.call(double)
      expect(patch).to eq(expected_patch)
    end
  end
end

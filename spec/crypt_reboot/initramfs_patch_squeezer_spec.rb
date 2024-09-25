# frozen_string_literal: true

module CryptReboot
  RSpec.describe InitramfsPatchSqueezer do
    subject(:squeezer) do
      described_class.new(
        extractor: ->(_, &b) { b.call('./spec/fixtures/extracted_initramfs/main') },
        zfs_keystore_entries_generator: -> { {} }
      )
    end

    let :expected_patch do
      {
        '/cryptroot/crypttab' => "# This file has been patched by cryptreboot\n" \
                                 'cryptswap /dev/null /dev/urandom ' \
                                 "swap,plain,offset=1024,cipher=aes-xts-plain64,size=512\n"
      }
    end

    it 'squeezes initramfs into a patch' do
      patch = squeezer.call(double)
      expect(patch).to eq(expected_patch)
    end
  end
end

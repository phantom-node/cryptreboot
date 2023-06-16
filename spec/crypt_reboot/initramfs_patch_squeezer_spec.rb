# frozen_string_literal: true

module CryptReboot
  RSpec.describe InitramfsPatchSqueezer do
    subject(:squeezer) do
      described_class.new(
        extractor: ->(_, &b) { b.call('./spec/fixtures/extracted_initramfs') }
      )
    end

    let :expected_patch do
      {
        '/cryptroot/crypttab' => "# This file has been patched by cryptreboot\n" \
                                 'cryptswap UUID=9fc8c882-f67f-4e44-89e0-7cd63be81fd5 /dev/urandom ' \
                                 'swap,plain,offset=1024,cipher=aes-xts-plain64,size=512'
      }
    end

    it 'squeezes initramfs into a patch' do
      patch = squeezer.call(double)
      expect(patch).to eq(expected_patch)
    end
  end
end

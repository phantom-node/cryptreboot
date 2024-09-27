# frozen_string_literal: true

module CryptReboot
  RSpec.describe LuksCryptTabPatcher do
    subject(:patcher) { described_class.new }

    let :expected_patch do
      {
        '/cryptroot/crypttab' => "# This file has been patched by cryptreboot\n" \
                                 'cryptswap /dev/null /dev/urandom ' \
                                 "swap,plain,offset=1024,cipher=aes-xts-plain64,size=512\n"
      }
    end

    it do
      patch = patcher.call('spec/fixtures/extracted_initramfs/luks_crypt_tab')
      expect(patch).to eq(expected_patch)
    end
  end
end

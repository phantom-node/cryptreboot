# frozen_string_literal: true

module CryptReboot
  module Initramfs
    class Decompressor
      RSpec.describe TolerantDecompressor do
        subject(:decompressor) do
          described_class.new(runner: runner)
        end

        let(:runner) { spy }

        it 'decompress' do
          decompressor.call('/boot/initrd.img', '/my/dir')
          expect(runner).to have_received(:call).with('unmkinitramfs', '/boot/initrd.img', '/my/dir')
        end
      end
    end
  end
end

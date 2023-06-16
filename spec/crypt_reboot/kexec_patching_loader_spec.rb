# frozen_string_literal: true

module CryptReboot
  RSpec.describe KexecPatchingLoader do
    subject(:loader) do
      described_class.new(
        generator: ->(image, &block) { block.call "patched-#{image}" },
        loader: kexec_loader
      )
    end

    let(:kexec_loader) { spy }

    it 'loads patched initramfs' do
      loader.call('kernel', 'cmdline', 'initramfs')
      expect(kexec_loader).to have_received(:call).with('kernel', 'cmdline', 'patched-initramfs')
    end
  end
end

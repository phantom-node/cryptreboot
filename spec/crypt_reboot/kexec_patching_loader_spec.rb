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
      boot_config = BootConfig.new(kernel: 'kernel', cmdline: 'cmdline', initramfs: 'initramfs')
      loader.call(boot_config)
      new_boot_config = boot_config.with_initramfs('patched-initramfs')
      expect(kexec_loader).to have_received(:call).with(new_boot_config)
    end
  end
end

# frozen_string_literal: true

module CryptReboot
  # Patch initramfs and load it along with kernel using kexec,
  # so it is ready to be executed.
  class KexecPatchingLoader
    def call(boot_config)
      generator.call(boot_config.initramfs) do |patched_initramfs|
        patched_boot_config = boot_config.with_initramfs(patched_initramfs)
        loader.call(patched_boot_config)
      end
    end

    private

    attr_reader :generator, :loader

    def initialize(generator: PatchedInitramfsGenerator.new,
                   loader: Kexec::Loader.new)
      @generator = generator
      @loader = loader
    end
  end
end

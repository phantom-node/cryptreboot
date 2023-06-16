# frozen_string_literal: true

module CryptReboot
  # Patch initramfs and load it along with kernel using kexec,
  # so it is ready to be executed.
  class KexecPatchingLoader
    def call(kernel_path, cmdline, initramfs_path)
      generator.call(initramfs_path) do |patched_initramfs_path|
        loader.call(kernel_path, cmdline, patched_initramfs_path)
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

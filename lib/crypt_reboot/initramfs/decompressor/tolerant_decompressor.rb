# frozen_string_literal: true

module CryptReboot
  module Initramfs
    class Decompressor
      # Simply extract initramfs
      class TolerantDecompressor
        def call(filename, dir)
          runner.call(unmkinitramfs, filename, dir)
        end

        private

        attr_reader :lazy_unmkinitramfs, :runner

        def unmkinitramfs
          lazy_unmkinitramfs.call
        end

        def initialize(lazy_unmkinitramfs: LazyConfig.unmkinitramfs_path,
                       runner: Runner::NoResult.new)
          @lazy_unmkinitramfs = lazy_unmkinitramfs
          @runner = runner
        end
      end
    end
  end
end

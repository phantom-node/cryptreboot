# frozen_string_literal: true

module CryptReboot
  module Initramfs
    RSpec.describe Decompressor do
      subject(:factory) do
        described_class.new
      end

      it 'returns tolerant compressor' do
        decompressor = factory.call(skip_lz4_check: true)
        expect(decompressor).to be_instance_of(Decompressor::TolerantDecompressor)
      end

      it 'returns intolerant compressor' do
        decompressor = factory.call(skip_lz4_check: false)
        expect(decompressor).to be_instance_of(Decompressor::IntolerantDecompressor)
      end
    end
  end
end

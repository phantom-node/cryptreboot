# frozen_string_literal: true

module CryptReboot
  module Initramfs
    RSpec.describe Decompressor do
      subject(:factory) do
        described_class.new
      end

      it 'returns tolerant compressor' do
        decompressor = factory.call(allow_lz4: true)
        expect(decompressor).to be_instance_of(Decompressor::TolerantDecompressor)
      end

      it 'returns intolerant compressor' do
        decompressor = factory.call(allow_lz4: false)
        expect(decompressor).to be_instance_of(Decompressor::IntolerantDecompressor)
      end
    end
  end
end

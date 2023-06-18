# frozen_string_literal: true

module CryptReboot
  module Luks
    RSpec.describe Checker do
      subject(:checker) { described_class.new }

      context 'when looking for LUKS2' do
        it 'recognizes LUKS2' do
          result = checker.call('spec/fixtures/luks_headers/v2.bin', 'LUKS2')
          expect(result).to be(true)
        end

        it 'returns false if given LUKS1' do
          result = checker.call('spec/fixtures/luks_headers/v1.bin', 'LUKS2')
          expect(result).to be(false)
        end

        it 'returns false on invalid header' do
          result = checker.call('spec/fixtures/luks_headers/invalid.bin', 'LUKS2')
          expect(result).to be(false)
        end
      end

      context 'when looking for LUKS1' do
        it 'recognizes LUKS1' do
          result = checker.call('spec/fixtures/luks_headers/v1.bin', 'LUKS1')
          expect(result).to be(true)
        end

        it 'returns false if given LUKS2' do
          result = checker.call('spec/fixtures/luks_headers/v2.bin', 'LUKS1')
          expect(result).to be(false)
        end

        it 'returns false on invalid header' do
          result = checker.call('spec/fixtures/luks_headers/invalid.bin', 'LUKS1')
          expect(result).to be(false)
        end
      end

      it 'returns false on invalid header when no LUKS version provided' do
        result = checker.call('spec/fixtures/luks_headers/invalid.bin')
        expect(result).to be(false)
      end
    end
  end
end

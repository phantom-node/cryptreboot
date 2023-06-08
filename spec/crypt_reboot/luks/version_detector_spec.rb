# frozen_string_literal: true

module CryptReboot
  module Luks
    RSpec.describe VersionDetector do
      subject(:detector) { described_class.new(verbose: true) }

      it 'recognizes LUKS2' do
        version = detector.call('spec/fixtures/luks_headers/v2.bin')
        expect(version).to eq('LUKS2')
      end

      it 'recognizes LUKS1' do
        version = detector.call('spec/fixtures/luks_headers/v1.bin')
        expect(version).to eq('LUKS1')
      end

      it 'fails on invalid header' do
        expect do
          detector.call('spec/fixtures/luks_headers/invalid.bin')
        end.to raise_error(VersionDetector::NotLuks)
      end

      context 'with no support for LUKS2' do
        subject(:detector) { described_class.new(verbose: true, supported_versions: ['LUKS1']) }

        it 'fails on LUKS2' do
          expect do
            detector.call('spec/fixtures/luks_headers/v2.bin')
          end.to raise_error(VersionDetector::UnsupportedVersion)
        end

        it 'still recognizes LUKS1' do
          version = detector.call('spec/fixtures/luks_headers/v1.bin')
          expect(version).to eq('LUKS1')
        end
      end
    end
  end
end

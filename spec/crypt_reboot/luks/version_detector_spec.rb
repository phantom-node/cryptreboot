# frozen_string_literal: true

module CryptReboot
  module Luks
    RSpec.describe VersionDetector do
      subject(:detector) do
        described_class.new(verbose: true, checker: checker, supported_versions: supported_versions)
      end

      let :checker do
        ->(headevice, version = :any) { device_db.fetch(headevice).include?(version) }
      end

      let :device_db do
        {
          '/dev/v2' => ['LUKS2', :any],
          '/dev/v1' => ['LUKS1', :any],
          '/dev/any' => [:any],
          '/dev/inv' => ['invalid']
        }
      end

      context 'with support for LUKS1 & LUKS2' do
        let(:supported_versions) { %w[LUKS2 LUKS1] }

        it 'recognizes LUKS2' do
          version = detector.call('/dev/v2')
          expect(version).to eq('LUKS2')
        end

        it 'recognizes LUKS1' do
          version = detector.call('/dev/v1')
          expect(version).to eq('LUKS1')
        end

        it 'fails on invalid header' do
          expect do
            detector.call('/dev/inv')
          end.to raise_error(VersionDetector::NotLuks)
        end
      end

      context 'with no support for LUKS2' do
        let(:supported_versions) { ['LUKS1'] }

        it 'fails on LUKS2' do
          expect do
            detector.call('/dev/v2')
          end.to raise_error(VersionDetector::UnsupportedVersion)
        end

        it 'still recognizes LUKS1' do
          version = detector.call('/dev/v1')
          expect(version).to eq('LUKS1')
        end
      end
    end
  end
end

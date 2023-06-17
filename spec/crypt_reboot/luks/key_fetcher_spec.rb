# frozen_string_literal: true

require 'tmpdir'

module CryptReboot
  module Luks
    RSpec.describe KeyFetcher do
      subject(:fetcher) do
        described_class.new(temp_provider: temp_provider)
      end

      let :temp_provider do
        SafeTemp::FileName.new(dir_provider: Dir.method(:mktmpdir))
      end

      context 'with valid passphrase' do
        let(:passphrase) { 'qwe' }

        context 'with LUKS2 header' do
          let(:header_file) { 'spec/fixtures/luks_headers/v2.bin' }

          let :expected_key do
            "\xeb\xd3\xe2\x08\xe4\x5f\xeb\x4d\x81\xd2\xd8\xc2\x79\xba\x6a\x9f" \
              "\xb0\xf8\xf2\xc4\x98\x9f\xa6\xed\xfb\x95\x52\x22\xe7\x96\x0f\x6d" \
              "\x25\x18\xba\x3a\x36\xed\x07\xa3\xf3\x9e\x93\x79\xb7\x47\xaf\x5d" \
              "\x8f\x87\x30\x56\x21\x76\x8a\x74\x87\x23\x91\xaa\xe4\xa7\xfc\x0b"
          end

          it 'fetches key' do
            key = fetcher.call(header_file, passphrase)
            expect(key).to eq(expected_key)
          end
        end

        context 'with LUKS1 header' do
          let(:header_file) { 'spec/fixtures/luks_headers/v1.bin' }

          let :expected_key do
            "\x41\x44\x91\xb7\xef\x52\x84\x4f\xc0\x2a\xf3\xbf\x97\xbb\x0b\x8b" \
              "\x06\x04\x57\xc4\x52\x2f\x7d\xdd\x8c\x2a\x59\x42\x64\xbd\x89\xa3" \
              "\x09\x1c\x6c\xa3\x57\x31\xe0\x59\x82\x6f\xe1\x25\x0b\x9c\xbf\x8c" \
              "\x3c\x16\x68\xc6\xb7\x37\xcc\x0e\x6e\x79\xab\xf5\x47\x3d\x85\xed"
          end

          it 'fetches key' do
            key = fetcher.call(header_file, passphrase)
            expect(key).to eq(expected_key)
          end
        end
      end

      context 'with invalid passphrase' do
        let(:passphrase) { 'invalid' }

        context 'with LUKS2 header' do
          let(:header_file) { 'spec/fixtures/luks_headers/v2.bin' }

          it 'fails' do
            expect do
              fetcher.call(header_file, passphrase)
            end.to raise_error(KeyFetcher::InvalidPassphrase)
          end
        end

        context 'with LUKS1 header' do
          let(:header_file) { 'spec/fixtures/luks_headers/v1.bin' }

          it 'fails' do
            expect do
              fetcher.call(header_file, passphrase)
            end.to raise_error(KeyFetcher::InvalidPassphrase)
          end
        end
      end
    end
  end
end

# frozen_string_literal: true

module CryptReboot
  module Luks
    RSpec.describe DataFetcher do
      subject(:fetcher) do
        described_class.new(
          asker: ->(_) { 'qwe' },
          key_fetcher: ->(_, _) { expected_data.key }
        )
      end

      context 'with LUKS2 header' do
        let :expected_data do
          Data.new(
            cipher: 'aes-xts-plain64',
            offset: 16_777_216,
            sector_size: 512,
            key: 'secret'
          )
        end

        it 'fetches data' do
          data = fetcher.call('spec/fixtures/luks_headers/v2.bin', 'v2')
          expect(data).to eq(expected_data)
        end
      end

      context 'with LUKS1 header' do
        let :expected_data do
          Data.new(
            cipher: 'aes-xts-plain64',
            offset: 0,
            sector_size: 512,
            key: 'secret'
          )
        end

        it 'fetches data' do
          data = fetcher.call('spec/fixtures/luks_headers/v1.bin', 'v1')
          expect(data).to eq(expected_data)
        end
      end
    end
  end
end

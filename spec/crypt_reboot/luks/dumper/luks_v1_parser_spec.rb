# frozen_string_literal: true

module CryptReboot
  module Luks
    class Dumper
      RSpec.describe LuksV1Parser do
        subject(:parser) do
          described_class.new
        end

        let :real_lines do
          File.readlines('spec/fixtures/luks_dump/v1.txt').map(&:chomp)
        end

        let :expected_data do
          Data.new(
            cipher: 'aes-xts-plain64',
            offset: 2_097_152,
            sector_size: 512
          )
        end

        it 'fetches data' do
          data = parser.call(real_lines)
          expect(data).to eq(expected_data)
        end

        it 'fails on empty data' do
          expect do
            parser.call([])
          end.to raise_error(LuksV1Parser::ParsingError)
        end

        it 'fails on incomplete data' do
          expect do
            parser.call(['Cipher name: ceasar', 'Cipher mode: xts-plain64'])
          end.to raise_error(LuksV1Parser::ParsingError)
        end

        it 'fails on duplicate data' do
          expect do
            parser.call(['Cipher name: ceasar', 'Cipher mode: 1', 'Payload offset: 1', 'Cipher mode: 2'])
          end.to raise_error(LuksV1Parser::ParsingError)
        end
      end
    end
  end
end

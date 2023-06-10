# frozen_string_literal: true

module CryptReboot
  module Luks
    class Dumper
      RSpec.describe LuksV2Parser do
        subject(:parser) do
          described_class.new
        end

        let :real_lines do
          File.readlines('spec/fixtures/luks_dump/v2.txt').map(&:chomp)
        end

        let :expected_data do
          Data.new(
            cipher: 'aes-xts-plain64',
            offset: 16_777_216,
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
          end.to raise_error(LuksV2Parser::ParsingError)
        end

        it 'fails on incomplete data' do
          expect do
            parser.call(['Data segments:', "\tcipher: ceasar"])
          end.to raise_error(LuksV2Parser::ParsingError)
        end

        it 'fails on duplicate data' do
          expect do
            parser.call(['Data segments:', "\tcipher: ceasar", "\toffset: 1 [bytes]",
                         "\tsector: 1 [bytes]", "\tcipher: ceasar"])
          end.to raise_error(LuksV2Parser::ParsingError)
        end

        it 'fails on data moved to another section' do
          expect do
            parser.call(['Data segments:', "\tcipher: ceasar", "\toffset: 1 [bytes]",
                         'Data segments:', "\tsector: 1 [bytes]"])
          end.to raise_error(LuksV2Parser::ParsingError)
        end
      end
    end
  end
end

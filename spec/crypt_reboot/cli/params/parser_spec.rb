# frozen_string_literal: true

module CryptReboot
  module Cli
    module Params
      RSpec.describe Parser do
        subject(:parser) do
          described_class.new
        end

        it 'parses valid params' do
          params = parser.call(['--kernel', 'kernel1', '--initramfs', 'initramfs1', '--cmdline', 'a b c'])
          expect(params).to include({ kernel: 'kernel1', initramfs: 'initramfs1', cmdline: 'a b c' })
        end

        it 'gets defaults' do
          params = parser.call([])
          expect(params).to include({ kernel: '/boot/vmlinuz' })
        end

        it 'fails on invalid params' do
          expect do
            parser.call(['--something'])
          end.to raise_error(Parser::ParseError)
        end
      end
    end
  end
end

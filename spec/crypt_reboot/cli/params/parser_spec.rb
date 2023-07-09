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

        it 'parses flattened params' do
          params = parser.call(['--tool', 'cat:/usr/bin/cat', '--tool', 'cpio:/usr/bin/cpio'])
          expect(params).to include({ cat_path: '/usr/bin/cat', cpio_path: '/usr/bin/cpio' })
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

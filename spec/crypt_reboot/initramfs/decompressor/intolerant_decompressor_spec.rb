# frozen_string_literal: true

module CryptReboot
  module Initramfs
    class Decompressor
      RSpec.describe IntolerantDecompressor do
        subject(:decompressor) do
          described_class.new(runner: runner)
        end

        context 'when ignoring result' do
          let(:memo) { spy }

          let :runner do
            lambda { |arg|
              memo.call(arg)
              []
            }
          end

          it 'executes correct command line' do
            decompressor.call('/boot/initrd.img', '/my/dir')
            expect(memo).to have_received(:call)
              .with('strace -f --trace=execve -z -qq --signal=\!all ' \
                    'unmkinitramfs /boot/initrd.img /my/dir ' \
                    '2>&1 | grep --line-buffered lz4')
          end

          it 'handles shell escaping' do
            decompressor.call(%(it's my "file" name), '/my|"nice/dir"')
            expect(memo).to have_received(:call)
              .with('strace -f --trace=execve -z -qq --signal=\!all ' \
                    "unmkinitramfs it\\'s\\ my\\ \\\"file\\\"\\ name /my\\|\\\"nice/dir\\\" " \
                    '2>&1 | grep --line-buffered lz4')
          end
        end

        context 'when ignoring command line being executed' do
          let :runner do
            ->(_) { lines }
          end

          context 'with command telling lz4 was used for test and real work' do
            let(:lines) do
              [
                'execve("/usr/bin/lz4cat", ["lz4cat", "-t"]',
                'execve("/usr/bin/lz4cat", ["lz4cat", "file"]'
              ]
            end

            it 'raises exception' do
              expect do
                decompressor.call('file', 'dir')
              end.to raise_error(IntolerantDecompressor::Lz4NotAllowed)
            end
          end

          context 'with command telling lz4 was used only for test (1)' do
            let(:lines) do
              [
                'execve("/usr/bin/lz4cat", ["lz4cat", "-t"]'
              ]
            end

            it 'does not raise exception' do
              expect do
                decompressor.call('file', 'dir')
              end.not_to raise_error
            end
          end

          context 'with command telling lz4 was used only for test (2)' do
            let(:lines) do
              [
                'execve("/usr/bin/lz4cat", ["lz4cat", "--test"]'
              ]
            end

            it 'does not raise exception' do
              expect do
                decompressor.call('file', 'dir')
              end.not_to raise_error
            end
          end

          context 'with command telling lz4 was not used at all' do
            let(:lines) { [] }

            it 'does not raise exception' do
              expect do
                decompressor.call('file', 'dir')
              end.not_to raise_error
            end
          end
        end
      end
    end
  end
end

# frozen_string_literal: true

module CryptReboot
  module Luks
    RSpec.describe CryptSetupRunner do
      subject(:cryptsetup) do
        described_class.new(runner: ->(*args, input: nil) { args + [input] })
      end

      it 'runs cryptsetup' do
        out = cryptsetup.call('luksDump', 'myheader', '--myflag')
        expect(out).to eq(['/usr/sbin/cryptsetup', 'luksDump', 'none', '--header', 'myheader', '--myflag', nil])
      end

      it 'runs cryptsetup with standard input' do
        out = cryptsetup.call('luksDump', 'myheader', input: 'abc')
        expect(out).to eq(['/usr/sbin/cryptsetup', 'luksDump', 'none', '--header', 'myheader', 'abc'])
      end

      context 'when cryptsetup fails' do
        subject(:cryptsetup) do
          described_class.new(
            runner: -> { raise ArgumentError },
            runner_exception: ArgumentError
          )
        end

        it 'fails with exception' do
          expect do
            cryptsetup.call('luksDump', 'myheader')
          end.to raise_error(CryptSetupRunner::ExitError)
        end
      end
    end
  end
end

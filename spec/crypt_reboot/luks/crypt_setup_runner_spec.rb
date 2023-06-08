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

      context 'with multiline output' do
        subject(:cryptsetup) do
          described_class.new(
            verbose: true,
            binary: '/usr/bin/echo'
          )
        end

        it 'returns array of lines' do
          result = cryptsetup.call("command\nnext_line", "something\nelse")
          expect(result).to eq(['command', 'next_line none --header something', 'else'])
        end
      end

      context 'with input' do
        subject(:cryptsetup) do
          described_class.new(
            verbose: true,
            binary: 'spec/fixtures/liberal_cat'
          )
        end

        it 'returns array of lines' do
          result = cryptsetup.call('dummy1', 'dummy2', input: 'this is input')
          expect(result).to eq(['this is input'])
        end
      end
    end
  end
end

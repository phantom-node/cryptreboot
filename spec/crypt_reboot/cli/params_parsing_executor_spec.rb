# frozen_string_literal: true

module CryptReboot
  module Cli
    RSpec.describe ParamsParsingExecutor do
      subject(:executor) { described_class.new(loader: loader, debug_checker: -> { debug }) }

      let(:loader) do
        -> { raise ZeroDivisionError, 'Loading failed' }
      end

      context 'when no real work has to be done' do
        let(:debug) { false }

        it 'returns help' do
          result = executor.call(['--help'])
          expect(result).to be_a(HappyExiter).and \
            have_attributes(text: a_string_including('Usage:', '--help', '--version', 'initramfs', 'cryptsetup'))
        end

        it 'returns version' do
          result = executor.call(['--version'])
          expect(result).to be_a(HappyExiter).and \
            have_attributes(text: a_string_including(VERSION))
        end

        it 'returns error if invalid flag specified' do
          result = executor.call(['--invalid-flag'])
          expect(result).to be_a(SadExiter).and \
            have_attributes(text: a_string_including('invalid option'))
        end

        it 'returns error if processing failed' do
          result = executor.call([])
          expect(result).to be_a(SadExiter).and have_attributes(text: 'Zero division error: Loading failed')
        end
      end

      context 'when real work needs to be done' do
        let(:debug) { false }

        let(:loader) { -> {} }

        it 'executes and returns rebooter' do
          result = executor.call([])
          expect(result).to be_an_instance_of(Rebooter)
        end

        it 'updates config when option is specified' do
          executor.call(['--prepare-only'])
          expect(Config.instance.prepare_only).to be(true)
        end
      end

      context 'with debug' do
        let(:debug) { true }

        it 'raises error if processing failed' do
          expect do
            executor.call([])
          end.to raise_error(ZeroDivisionError)
        end

        it 'raises error on invalid flag' do
          expect do
            executor.call(['--invalid-flag'])
          end.to raise_error(Params::Parser::ParseError)
        end
      end
    end
  end
end

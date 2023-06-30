# frozen_string_literal: true

module CryptReboot
  module Cli
    RSpec.describe ParamsParsingExecutor do
      subject(:executor) do
        described_class.new(
          loader: loader,
          debug_checker: -> { config.debug },
          config_updater: config.method(:update!)
        )
      end

      let(:config) { InstantiableConfig.new }

      context 'when no real work will be done' do
        let(:loader) do
          -> { raise ZeroDivisionError, 'Loading failed' }
        end

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

        it 'raises error if processing failed and debug flag present' do
          expect do
            executor.call(['--debug'])
          end.to raise_error(ZeroDivisionError)
        end

        it 'does not raise errors caused by processing params if debug flag present' do
          result = executor.call(['--debug', '--invalid-flag'])
          expect(result).to be_a(SadExiter).and \
            have_attributes(text: a_string_including('invalid option'))
        end
      end

      context 'when real work will be done' do
        let(:loader) { -> {} }

        it 'executes and returns rebooter' do
          result = executor.call([])
          expect(result).to be_an_instance_of(Rebooter)
        end

        it 'updates config when option is specified' do
          executor.call(['--prepare-only'])
          expect(config.prepare_only).to be(true)
        end
      end
    end
  end
end

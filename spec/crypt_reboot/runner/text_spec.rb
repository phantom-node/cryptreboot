# frozen_string_literal: true

module CryptReboot
  module Runner
    RSpec.describe Text do
      subject(:runner) do
        described_class.new
      end

      it 'returns standard output as text' do
        result = runner.call('echo 123')
        expect(result).to eq("123\n")
      end

      it 'raises exception on error' do
        expect do
          runner.call('false')
        end.to raise_error(ExitError)
      end

      it 'raises exception on not found error' do
        expect do
          runner.call('dfkjgaksjdgfkajsghd')
        end.to raise_error(CommandNotFound)
      end
    end
  end
end

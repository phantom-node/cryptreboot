# frozen_string_literal: true

module CryptReboot
  module Runner
    RSpec.describe Lines do
      subject(:runner) do
        described_class.new
      end

      it 'returns standard output as array of lines' do
        result = runner.call('echo "123\n456"')
        expect(result).to eq(%w[123 456])
      end

      it 'raises exception on error' do
        expect do
          runner.call('false')
        end.to raise_error(ExitError)
      end

      it 'raises exception on other errors' do
        expect do
          runner.call('dfkjgaksjdgfkajsghd')
        end.to raise_error(Errno::ENOENT)
      end
    end
  end
end

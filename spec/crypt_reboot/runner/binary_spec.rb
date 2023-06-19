# frozen_string_literal: true

module CryptReboot
  module Runner
    RSpec.describe Binary do
      subject(:runner) do
        described_class.new
      end

      it 'returns string of zeros' do
        result = runner.call('dd', 'if=/dev/zero', 'bs=1c', 'count=8')
        expect(result).to eq("\0" * 8)
      end

      it 'returns line endings' do
        result = runner.call('echo', '-n', '\r\n\r\n\n\r')
        expect(result).to eq("\r\n\r\n\n\r")
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

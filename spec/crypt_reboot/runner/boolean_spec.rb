# frozen_string_literal: true

module CryptReboot
  module Runner
    RSpec.describe Boolean do
      subject(:runner) do
        described_class.new
      end

      it 'returns true on success' do
        result = runner.call('true')
        expect(result).to be(true)
      end

      it 'returns false on failure' do
        result = runner.call('false')
        expect(result).to be(false)
      end

      it 'raises exception on not found error' do
        expect do
          runner.call('dfkjgaksjdgfkajsghd')
        end.to raise_error(CommandNotFound)
      end
    end
  end
end

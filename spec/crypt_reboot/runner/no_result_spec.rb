# frozen_string_literal: true

require 'tmpdir'

module CryptReboot
  module Runner
    RSpec.describe NoResult do
      subject(:runner) do
        described_class.new
      end

      it 'ignores output' do
        result = runner.call('echo "123\n456"')
        expect(result).to be_nil
      end

      it 'executes command' do
        Dir.mktmpdir do |dir|
          tmp_file = File.join(dir, 'file.txt')
          runner.call('touch', tmp_file)
          expect(File).to exist(tmp_file)
        end
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

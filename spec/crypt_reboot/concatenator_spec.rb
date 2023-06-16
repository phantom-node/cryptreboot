# frozen_string_literal: true

require 'tmpdir'

module CryptReboot
  RSpec.describe Concatenator do
    subject(:cat) do
      described_class.new(verbose: true)
    end

    it 'concatenates files' do
      Dir.mktmpdir do |dir|
        result_path = File.join(dir, 'result.txt')
        cat.call('spec/fixtures/concatenator/f1.txt', 'spec/fixtures/concatenator/f2.txt', to: result_path)
        expect(File.read(result_path)).to eq("f1\nf2\n")
      end
    end
  end
end

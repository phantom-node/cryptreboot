# frozen_string_literal: true

require 'tempfile'

module CryptReboot
  RSpec.describe Gziper do
    subject(:gziper) { described_class.new }

    it 'creates correctly formatted gzip file' do
      Tempfile.open do |file|
        gziper.call(file.path, 'This will be compressed')
        result = system("gzip -t #{file.path}")
        expect(result).to be(true)
      end
    end
  end
end

# frozen_string_literal: true

require 'stringio'

module CryptReboot
  module Cli
    RSpec.describe Exiter do
      it 'returns status' do
        result = described_class.new(nil, status: 123, stream: $stdout).call
        expect(result).to eq(123)
      end

      it 'prints message' do
        io = StringIO.new
        described_class.new('message', status: double, stream: io).call
        expect(io.string).to eq("message\n")
      end

      it 'does not print a message if nil' do
        io = StringIO.new
        described_class.new(nil, status: double, stream: io).call
        expect(io.string).to be_empty
      end
    end
  end
end

# frozen_string_literal: true

module CryptReboot
  module Cli
    module Params
      RSpec.describe HelpGenerator do
        it 'returns usage instructions' do
          usage = described_class.new.call
          expect(usage).to include('Usage:', '--help', '--version', 'initramfs', 'cryptsetup')
        end
      end
    end
  end
end

# frozen_string_literal: true

module CryptReboot
  module CryptTab
    RSpec.describe KeyfileLocator do
      subject(:locator) do
        described_class.new
      end

      it 'returns key location' do
        path = locator.call('target')
        expect(path).to eq('/cryptreboot/target.key')
      end
    end
  end
end

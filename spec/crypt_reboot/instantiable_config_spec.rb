# frozen_string_literal: true

require 'tmpdir'

module CryptReboot
  RSpec.describe InstantiableConfig do
    subject(:config) { described_class.new }

    it 'provides default value' do
      expect(config.cat_path).to eq('cat')
    end

    it 'allows to be updated' do
      config.update!(cat_path: 'dog')
      expect(config.cat_path).to eq('dog')
    end

    it 'does not allow to update unknown settings' do
      expect do
        config.update!(dog_path: 'something')
      end.to raise_error(InstantiableConfig::UnrecognizedSetting)
    end
  end
end

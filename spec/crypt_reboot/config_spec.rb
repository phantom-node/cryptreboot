# frozen_string_literal: true

require 'tmpdir'

module CryptReboot
  RSpec.describe Config do
    subject(:config) { described_class }

    def patch(value)
      "#{value}-patched"
    end

    it 'retrieves a setting' do
      old_value = config.cat_path
      config.update!(cat_path: patch(old_value))
      result = config.cat_path
      expect(result).to eq(patch(old_value))
      config.update!(cat_path: old_value)
    end
  end
end

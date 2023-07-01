# frozen_string_literal: true

require 'tmpdir'

module CryptReboot
  RSpec.describe LazyConfig do
    subject(:config) { described_class }

    def patch(value)
      "#{value}-patched"
    end

    it 'retrieves getter for a setting' do
      old_value = config.cpio_path.call
      getter = config.cpio_path
      config.update!(cpio_path: patch(old_value)).call
      expect(getter.call).to eq(patch(old_value))
      config.update!(cpio_path: old_value).call
    end
  end
end

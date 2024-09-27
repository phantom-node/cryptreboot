# frozen_string_literal: true

module CryptReboot
  module CryptTab
    RSpec.describe ZfsKeystoreEntriesGenerator do
      subject(:generator) do
        described_class.new(zvol_dir: 'spec/fixtures/zfs_dev/zvol')
      end

      let :expected_result do
        [
          Entry.new(
            target: 'keystore-rpool',
            source: 'spec/fixtures/zfs_dev/zvol/rpool/keystore',
            key_file: 'none',
            options: {},
            flags: %i[luks discard]
          )
        ]
      end

      it do
        result = generator.call
        expect(result).to eq(expected_result)
      end
    end
  end
end

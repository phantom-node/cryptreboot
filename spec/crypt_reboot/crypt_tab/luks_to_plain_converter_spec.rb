# frozen_string_literal: true

module CryptReboot
  module CryptTab
    RSpec.describe LuksToPlainConverter do
      subject(:converter) do
        described_class.new
      end

      let :luks_entry do
        Entry.new(
          target: 'target',
          source: 'source',
          key_file: 'my_keyfile',
          options: {
            'keyfile-size': 1,
            keyslot: 2,
            'key-slot': 3,
            header: 'a',
            keyscript: 'b',
            option1: 'c',
            option2: 'd',
            cipher: 'ignored_in_luks'
          }.merge(luks_options),
          flags: %i[luks flag1 flag2]
        )
      end

      let :plain_entry do
        Entry.new(
          target: 'target',
          source: 'source',
          key_file: '/my/secret.key',
          options: {
            option1: 'c',
            option2: 'd',
            cipher: 'caesar-ecb',
            size: 256,
            offset: 100
          }.merge(plain_options),
          flags: %i[flag1 flag2 plain]
        )
      end

      let :data do
        Luks::Data.new(
          cipher: 'caesar-ecb',
          offset: 51200,
          sector_size: 4096,
          key: "\x0" * 32
        )
      end

      let(:luks_options) { {} }
      let(:plain_options) { {} }

      context 'with user-supplied sector size' do
        let(:luks_options) { { 'sector-size': 512 } }
        let(:plain_options) { { 'sector-size': 512 } }

        it 'converts entry to plain' do
          new_entry = converter.call(luks_entry, data, '/my/secret.key')
          expect(new_entry).to eq(plain_entry)
        end
      end

      context 'with detected sector size' do
        let(:plain_options) { { 'sector-size': 4096 } }

        it 'converts entry to plain' do
          new_entry = converter.call(luks_entry, data, '/my/secret.key')
          expect(new_entry).to eq(plain_entry)
        end
      end
    end
  end
end

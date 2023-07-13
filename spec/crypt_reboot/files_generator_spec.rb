# frozen_string_literal: true

module CryptReboot
  RSpec.describe FilesGenerator do
    subject(:generator) do
      described_class.new(
        luks_checker: checker,
        luks_data_fetcher: fetcher,
        serializer: serializer
      )
    end

    let :checker do
      ->(headevice) { headevice != '/dev/non_luks_source' }
    end

    let :fetcher do
      lambda { |headevice, _target|
        keys = {
          '/dev/source1' => 'key1',
          '/dev/source2' => 'key2',
          '/dev/luks_source' => 'luks_key',
          '/my/base/dir/my/header.luks' => 'header_key'
        }

        Luks::Data.new(cipher: 'caesar-ecb', offset: 123,
                       sector_size: 4096, key: keys[headevice])
      }
    end

    let :serializer do
      ->(entries) { entries.map(&:target).join("\n") }
    end

    def create_entry(target, source, **options)
      CryptTab::Entry.new(
        target: target, source: source, key_file: 'my_keyfile',
        options: options, flags: []
      )
    end

    context 'with empty crypttab' do
      let :crypttab do
        []
      end

      let :expected_files do
        { '/cryptroot/crypttab' => '' }
      end

      it 'generates files hash' do
        files = generator.call(crypttab, '/ignored')
        expect(files).to eq(expected_files)
      end
    end

    context 'with crypttab containing two LUKS devices' do
      let :crypttab do
        [
          create_entry('target1', '/dev/source1'),
          create_entry('target2', '/dev/source2')
        ]
      end

      let :expected_files do
        {
          '/cryptreboot/target1.key' => 'key1',
          '/cryptreboot/target2.key' => 'key2',
          '/cryptroot/crypttab' => "target1\ntarget2"
        }
      end

      it 'generates files hash' do
        files = generator.call(crypttab, '/ignored')
        expect(files).to eq(expected_files)
      end
    end

    context 'with crypttab containing mix of LUKS and non-LUKS devices' do
      let :crypttab do
        [
          create_entry('luks', '/dev/luks_source'),
          create_entry('non_luks', '/dev/non_luks_source')
        ]
      end

      let :expected_files do
        {
          '/cryptreboot/luks.key' => 'luks_key',
          '/cryptroot/crypttab' => "luks\nnon_luks"
        }
      end

      it 'generates files hash' do
        files = generator.call(crypttab, '/ignored')
        expect(files).to eq(expected_files)
      end
    end

    context 'with crypttab containing LUKS entry with detached header' do
      let :crypttab do
        [
          create_entry('luks', '/dev/luks_source', header: '/my/header.luks')
        ]
      end

      let :expected_files do
        {
          '/cryptreboot/luks.key' => 'header_key',
          '/cryptroot/crypttab' => 'luks'
        }
      end

      it 'generates files hash' do
        files = generator.call(crypttab, '/my/base/dir')
        expect(files).to eq(expected_files)
      end
    end
  end
end

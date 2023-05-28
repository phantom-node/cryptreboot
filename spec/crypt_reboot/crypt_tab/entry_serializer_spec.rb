# frozen_string_literal: true

module CryptReboot
  module CryptTab
    RSpec.describe EntrySerializer do
      subject(:serializer) { described_class.new }

      let :entry do
        Entry.new({
                    target: 'cryptswap',
                    source: 'UUID=946d9327-0de2-4d7b-adba-28a079131b4c',
                    key_file: '/dev/urandom',
                    options: {
                      'offset' => '1024',
                      'cipher' => 'aes-xts-plain64',
                      'size' => '512'
                    },
                    flags: %w[swap plain]
                  })
      end

      let :expected_result do
        'cryptswap UUID=946d9327-0de2-4d7b-adba-28a079131b4c ' \
          '/dev/urandom swap,plain,offset=1024,cipher=aes-xts-plain64,size=512'
      end

      it 'deserializes complex example' do
        result = serializer.call(entry)
        expect(result).to eq(expected_result)
      end
    end
  end
end

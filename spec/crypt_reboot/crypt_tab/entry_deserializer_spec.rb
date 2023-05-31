# frozen_string_literal: true

module CryptReboot
  module CryptTab
    RSpec.describe EntryDeserializer do
      subject(:deserializer) { described_class.new }

      let :crypttab_line do
        'cryptswap UUID=946d9327-0de2-4d7b-adba-28a079131b4c ' \
          '/dev/urandom swap,plain,offset=1024,cipher=aes-xts-plain64,size=512'
      end

      let :expected_result do
        Entry.new({
                    target: 'cryptswap',
                    source: 'UUID=946d9327-0de2-4d7b-adba-28a079131b4c',
                    key_file: '/dev/urandom',
                    options: {
                      offset: 1024,
                      cipher: 'aes-xts-plain64',
                      size: 512
                    },
                    flags: %i[swap plain]
                  })
      end

      it 'deserializes complex example' do
        result = deserializer.call(crypttab_line)
        expect(result).to eq(expected_result)
      end
    end
  end
end

# frozen_string_literal: true

module CryptReboot
  module CryptTab
    RSpec.describe Deserializer do
      subject(:deserializer) do
        described_class.new(entry_deserializer: entry_deserializer)
      end

      let :entry_deserializer do
        ->(line) { line.split[1] }
      end

      let :crypttab_content do
        "# comment1 \n" \
          "cryptdata UUID=93115b73-4ddb-4a84-8ff4-3d0ef612e895 none luks\n" \
          "# comment 2\n" \
          'cryptswap UUID=5e14f95d-6549-4ecf-8d67-6db87d029a51 /dev/urandom ' \
          'swap,plain,offset=1024,cipher=aes-xts-plain64,size=512'
      end

      let :expected_result do
        [
          'UUID=93115b73-4ddb-4a84-8ff4-3d0ef612e895',
          'UUID=5e14f95d-6549-4ecf-8d67-6db87d029a51'
        ]
      end

      it 'deserializes crypttab file' do
        result = deserializer.call(content: crypttab_content)
        expect(result).to eq(expected_result)
      end
    end
  end
end

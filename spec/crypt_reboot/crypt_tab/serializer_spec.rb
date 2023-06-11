# frozen_string_literal: true

module CryptReboot
  module CryptTab
    RSpec.describe Serializer do
      subject(:serializer) do
        described_class.new(entry_serializer: entry_serializer, header: '# Comment')
      end

      let :entry_serializer do
        ->(entry) { "line:#{entry}" }
      end

      let :entries do
        [1, 2, 3]
      end

      let :expected_crypttab do
        "# Comment\n" \
          "line:1\n" \
          "line:2\n" \
          'line:3'
      end

      it 'serializes entries' do
        crypttab = serializer.call(entries)
        expect(crypttab).to eq(expected_crypttab)
      end
    end
  end
end

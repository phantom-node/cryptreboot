# frozen_string_literal: true

module CryptReboot
  module CryptTab
    RSpec.describe Entry do
      let :header do
        described_class.new(
          target: 'target1',
          source: 'source1',
          key_file: 'key_file1',
          options: { header: '/my/header.bin' },
          flags: []
        )
      end

      let :device do
        described_class.new(
          target: 'target1',
          source: '/dev/my_device',
          key_file: 'key_file1',
          options: {},
          flags: []
        )
      end

      it 'returns header file path' do
        expect(header.headevice).to eq('/my/header.bin')
      end

      it 'returns device path' do
        expect(device.headevice).to eq('/dev/my_device')
      end

      it 'does not equal if entries are different' do
        expect(header).not_to eq(device)
      end
    end
  end
end

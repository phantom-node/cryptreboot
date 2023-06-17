# frozen_string_literal: true

require 'tmpdir'

module CryptReboot
  module Luks
    RSpec.describe Data do
      def data(args)
        described_class.new(**args)
      end

      let :default_params do
        { cipher: 'caesar-ecb', offset: 123, sector_size: 4096 }
      end

      let :with_key do
        default_params.merge(
          { key: "\x06\x04\x57\xc4\x52\x2f\x7d\xdd\x8c\x2a\x59\x42\x64\xbd\x89\xa3" }
        )
      end

      it 'may be constructed without key' do
        expect(data(default_params).key).to be_empty
      end

      it 'may be constructed with key' do
        expect(data(with_key).key).not_to be_empty
      end

      it 'returns true if comparing two identical objects' do
        one = data(default_params)
        two = data(default_params)
        expect(one == two).to be(true)
      end

      it 'returns false if comparing two different objects' do
        one = data(default_params)
        two = data(default_params.merge(cipher: 'aes-cbc'))
        expect(one == two).to be(false)
      end

      it 'adds key' do
        new_data = data(default_params).dup_adding_key('secret')
        expected_data = data(default_params.merge({ key: 'secret' }))
        expect(new_data).to eq(expected_data)
      end

      it 'calculates key bits correctly' do
        expect(data(with_key).key_bits).to eq(128)
      end
    end
  end
end

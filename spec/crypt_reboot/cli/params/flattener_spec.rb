# frozen_string_literal: true

module CryptReboot
  module Cli
    module Params
      RSpec.describe Flattener do
        subject(:flattener) do
          described_class.new(key: 'paths', suffix: '_path')
        end

        it 'flattens params' do
          result = flattener.call({ param1: 1, paths: { tool1: 'a', tool2: 'b' } })
          expect(result).to eq({ param1: 1, tool1_path: 'a', tool2_path: 'b' })
        end

        it 'passes through behave empty params' do
          result = flattener.call({})
          expect(result).to eq({})
        end

        it 'passes through behave params without key' do
          result = flattener.call({ param1: 1 })
          expect(result).to eq({ param1: 1 })
        end
      end
    end
  end
end

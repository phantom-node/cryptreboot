# frozen_string_literal: true

module CryptReboot
  RSpec.describe SingleAssignRestrictedMap do
    subject(:map) do
      described_class.new
    end

    it 'returns hash if all required fields were passed' do
      map[:field1] = 1
      map[:field2] = 2
      expect(map.to_h).to eq({field1: 1, field2: 2})
    end

    it 'fails when trying to assign twice' do
      map[:field1] = 1
      expect do
        map[:field1] = 2
      end.to raise_error(SingleAssignRestrictedMap::AlreadyAssigned)
    end
  end
end

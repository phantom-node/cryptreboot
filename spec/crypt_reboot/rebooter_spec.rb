# frozen_string_literal: true

module CryptReboot
  RSpec.describe Rebooter do
    subject(:rebooter) { described_class.new(runner: runner, exiter: exiter) }

    let(:runner) { spy }
    let(:exiter) { spy }

    it 'reboots' do
      rebooter.call(true)
      expect(runner).to have_received(:call)
    end

    it 'exits without reboot' do
      rebooter.call(false)
      expect(exiter).to have_received(:call)
    end
  end
end

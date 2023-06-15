# frozen_string_literal: true

require 'tmpdir'

module CryptReboot
  module SafeTemp
    RSpec.describe Mounter do
      def ignore_exception
        yield
      rescue StandardError
        # ignore
      end

      it 'mounts, yields and unmounts' do
        ops = []
        mounter = described_class.new(mounter: ->(dir) { ops += ['mount', dir] },
                                      umounter: ->(dir) { ops += ['umount', dir] })
        mounter.call('d1') { ops << 'yield' }
        expect(ops).to eq(%w[mount d1 yield umount d1])
      end

      it 'mounts and unmounts, even in case of exception in block' do
        ops = []
        mounter = described_class.new(mounter: ->(dir) { ops += ['mount', dir] },
                                      umounter: ->(dir) { ops += ['umount', dir] })
        ignore_exception { mounter.call('d1') { raise StandardError } }
        expect(ops).to eq(%w[mount d1 umount d1])
      end

      it 'raises error if mount failed' do
        mounter = described_class.new(mounter: proc { raise ZeroDivisionError }, exception_class: ZeroDivisionError)
        expect do
          mounter.call('d1') { raise StandardError }
        end.to raise_error(Mounter::Error)
      end

      it 'does not yield or unmount if mount failed' do
        ops = []
        mounter = described_class.new(mounter: proc { raise StandardError },
                                      umounter: ->(dir) { ops += ['umount', dir] })
        ignore_exception { mounter.call('d1') { ops << 'yield' } }
        expect(ops).to eq(%w[])
      end

      it 'raises error if unmount failed' do
        mounter = described_class.new(mounter: proc {}, umounter: proc { raise ZeroDivisionError },
                                      exception_class: ZeroDivisionError)
        expect do
          mounter.call('d1') { raise StandardError }
        end.to raise_error(Mounter::Error)
      end

      it 'mounts, yields and raises because of unmounting failure' do
        ops = []
        mounter = described_class.new(mounter: ->(dir) { ops += ['mount', dir] },
                                      umounter: proc { raise StandardError })
        ignore_exception { mounter.call('d1') { ops << 'yield' } }
        expect(ops).to eq(%w[mount d1 yield])
      end
    end
  end
end

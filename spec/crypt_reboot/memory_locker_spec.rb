# frozen_string_literal: true

require 'English'

module CryptReboot
  RSpec.describe MemoryLocker do
    subject(:locker) { described_class.new }

    let(:lock_failed) { 10 }
    let(:lock_unchanged) { 20 }
    let(:lock_success) { 0 }

    def lock
      locker.call
    rescue MemoryLocker::Error
      exit lock_failed
    end

    def locked
      File.readlines('/proc/self/status').grep(/^VmLck/)
          .first.split("\t").last.strip
    end

    def locked_changed?
      before = locked
      yield
      locked != before
    end

    def fork_status(&block)
      fork(&block)
      Process.wait
      $CHILD_STATUS.exitstatus
    end

    it 'locks memory' do
      status = fork_status do
        changed = locked_changed? { lock }
        exit lock_unchanged unless changed
      end
      expect(status).to eq(lock_success)
    end

    it 'fails to lock memory' do
      status = fork_status do
        Process.setrlimit(:MEMLOCK, 0)
        lock
      end
      expect(status).to eq(lock_failed)
    end
  end
end

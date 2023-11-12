# frozen_string_literal: true

require 'memory_locker' unless defined? MemoryLocker # MemoryLocker is mocked in tests

module CryptReboot
  # Try to lock memory if configuration allows it
  class ElasticMemoryLocker
    LockingError = Class.new StandardError

    def call
      return if skip_locking?

      locker.call
      nil
    rescue locking_error => e
      raise LockingError, 'Failed to lock memory', cause: e
    end

    private

    def skip_locking?
      insecure_memory_checker.call
    end

    attr_reader :insecure_memory_checker, :locker, :locking_error

    def initialize(insecure_memory_checker: LazyConfig.insecure_memory,
                   locker: MemoryLocker,
                   locking_error: MemoryLocker::Error)
      @insecure_memory_checker = insecure_memory_checker
      @locker = locker
      @locking_error = locking_error
    end
  end
end

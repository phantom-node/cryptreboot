# frozen_string_literal: true

module CryptReboot
  # Try to lock memory if configuration allows it
  class ElasticMemoryLocker
    LockingError = Class.new StandardError

    def call
      return if skip_locking?

      loader.call
      locker.call
      nil
    rescue load_error, locking_error => e
      raise LockingError, 'Failed to lock memory', cause: e
    end

    private

    def skip_locking?
      insecure_memory_checker.call
    end

    def locking_error
      lazy_locking_error.call
    end

    attr_reader :insecure_memory_checker, :loader, :load_error, :locker, :lazy_locking_error

    def initialize(insecure_memory_checker: LazyConfig.insecure_memory,
                   loader: -> { require 'memory_locker' },
                   load_error: LoadError,
                   locker: -> { MemoryLocker.call },
                   lazy_locking_error: -> { MemoryLocker::Error })
      @insecure_memory_checker = insecure_memory_checker
      @loader = loader
      @load_error = load_error
      @locker = locker
      @lazy_locking_error = lazy_locking_error
    end
  end
end

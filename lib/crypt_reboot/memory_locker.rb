# frozen_string_literal: true

require 'ffi'

module CryptReboot
  # Lock process memory, so it won't be swapped by the kernel.
  # It is implemented as a one-way operation: there is no unlock.
  # That's because it's hard to properly clean memory in Ruby.
  class MemoryLocker
    Error = Class.new StandardError

    def call
      return if Libc.mlockall(Libc::MCL_CURRENT | Libc::MCL_FUTURE).zero?

      raise Error, "Failed to lock memory: #{FFI.errno}"
    end

    # Low level interface to libc
    module Libc
      extend FFI::Library
      ffi_lib 'libc.so.6'

      # define mlockall constants
      MCL_CURRENT = 1
      MCL_FUTURE = 2
      MCL_ONFAULT = 4

      # declare mlockall function
      attach_function :mlockall, [:int], :int
    end
    private_constant :Libc
  end
end

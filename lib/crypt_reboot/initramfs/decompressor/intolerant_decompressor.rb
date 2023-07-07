# frozen_string_literal: true

require 'shellwords'

module CryptReboot
  module Initramfs
    # Extract initramfs in strace to check if compression is supported
    class Decompressor
      class IntolerantDecompressor
        Lz4NotAllowed = Class.new StandardError

        def call(filename, dir)
          command_line = prepare_command_line(filename, dir)
          lines = runner.call(command_line)
          raise_exception if intolerable_tool_used?(lines)
        end

        private

        def prepare_command_line(filename, dir)
          options = '-f --trace=execve -z -qq --signal=\!all'
          args = "#{filename.shellescape} #{dir.shellescape}"
          strace_command_line = "#{strace.shellescape} #{options} #{unmkinitramfs.shellescape} #{args}"
          grep_command_line = "#{grep.shellescape} --line-buffered lz4"
          "#{strace_command_line} 2>&1 | #{grep_command_line}"
        end

        def intolerable_tool_used?(lines)
          !!lines.find { |line| line !~ /"-t"/ && line !~ /"--test"/ }
        end

        def raise_exception
          raise Lz4NotAllowed, 'Lz4 compression not allowed, change compression algorithm ' \
                               'in initramfs.conf and regenerate initramfs image'
        end

        def unmkinitramfs
          lazy_unmkinitramfs.call
        end

        def strace
          lazy_strace.call
        end

        def grep
          lazy_grep.call
        end

        attr_reader :lazy_unmkinitramfs, :lazy_strace, :lazy_grep, :runner

        def initialize(lazy_unmkinitramfs: LazyConfig.unmkinitramfs_path,
                       lazy_strace: LazyConfig.strace_path,
                       lazy_grep: LazyConfig.grep_path,
                       runner: Runner::NoResult.new)
          @lazy_unmkinitramfs = lazy_unmkinitramfs
          @lazy_strace = lazy_strace
          @lazy_grep = lazy_grep
          @runner = runner
        end
      end
    end
  end
end

# frozen_string_literal: true

module CryptReboot
  module CryptTab
    # Value-object describing entry in crypttab file
    class Entry
      attr_reader :target, :source, :key_file, :options, :flags

      def ==(other)
        target == other.target && source == other.source && key_file == other.key_file &&
          options == other.options && flags == other.flags
      end

      def headevice
        options[:header] || source
      end

      private

      def initialize(target:, source:, key_file:, options:, flags:)
        @target = target
        @source = source
        @key_file = key_file
        @options = options
        @flags = flags
      end
    end
  end
end

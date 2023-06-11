# frozen_string_literal: true

module CryptReboot
  module CryptTab
    # Value-object describing entry in crypttab file
    class Entry
      attr_reader :target, :source, :key_file, :options, :flags

      def ==(other)
        target == other.target && source == other.source && key_file == other.key_file &&
          options == other.options && flags.sort == other.flags.sort
      end

      def headevice(header_prefix: nil)
        if header_prefix && header_path
          File.join(header_prefix, header_path)
        elsif header_path
          header_path
        else
          source
        end
      end

      private

      def header_path
        options[:header]
      end

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

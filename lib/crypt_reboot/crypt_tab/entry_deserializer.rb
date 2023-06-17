# frozen_string_literal: true

module CryptReboot
  module CryptTab
    # Deserialize crypttab line into value object
    class EntryDeserializer
      InvalidFormat = Class.new StandardError

      def call(line)
        target, source, key_file, raw_floptions = columns = line.split
        raise InvalidFormat if columns.size < 3

        floptions = raw_floptions.to_s.split(',')
        flags = extract_flags(floptions)
        options = extract_options(floptions)
        entry_class.new(
          target: target, source: source, key_file: key_file,
          options: options, flags: flags
        )
      end

      private

      def extract_flags(floptions)
        floptions.reject do |floption|
          floption.include?('=')
        end.map(&:to_sym)
      end

      def extract_options(floptions)
        options = floptions.select do |floption|
          floption.include?('=')
        end
        options.to_h do |option|
          parse_option(option)
        end
      end

      def parse_option(option)
        name, value = option.split('=')
        [name.to_sym, value.to_i.to_s == value ? value.to_i : value]
      end

      attr_reader :entry_class

      def initialize(entry_class: Entry)
        @entry_class = entry_class
      end
    end
  end
end

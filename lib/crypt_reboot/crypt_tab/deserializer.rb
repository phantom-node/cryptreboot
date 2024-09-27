# frozen_string_literal: true

module CryptReboot
  module CryptTab
    # Load crypttab file and return array with deserialized entries
    class Deserializer
      def call(filename = nil, content: File.read(filename))
        split_to_important_lines(content).map do |line|
          entry_deserializer.call line
        end
      end

      private

      def split_to_important_lines(content)
        content.split(/\n+|\r+/)
               .reject(&:empty?)
               .reject { |line| line.start_with? '#' }
      end

      attr_reader :entry_deserializer

      def initialize(entry_deserializer: EntryDeserializer.new)
        @entry_deserializer = entry_deserializer
      end
    end
  end
end

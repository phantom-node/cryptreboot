# frozen_string_literal: true

module CryptReboot
  module CryptTab
    # Load crypttab file and return array with deserialized entries
    class Loader
      def call(filename = nil, content: File.read(filename))
        split_to_important_lines(content).map do |line|
          deserializer.call line
        end
      end

      private

      def split_to_important_lines(content)
        content.split(/\n+|\r+/)
               .reject(&:empty?)
               .reject { |line| line.start_with? '#' }
      end

      attr_reader :deserializer

      def initialize(deserializer: EntryDeserializer.new)
        @deserializer = deserializer
      end
    end
  end
end

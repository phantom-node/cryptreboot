# frozen_string_literal: true

module CryptReboot
  module CryptTab
    # Serialize entries and return crypttab file content as a string
    class Serializer
      def call(entries)
        body = serialize(entries).join("\n")
        "#{header}\n#{body}\n"
      end

      private

      def serialize(entries)
        entries.map do |entry|
          entry_serializer.call(entry)
        end
      end

      attr_reader :entry_serializer, :header

      def initialize(entry_serializer: EntrySerializer.new,
                     header: '# This file has been patched by cryptreboot')
        @entry_serializer = entry_serializer
        @header = header
      end
    end
  end
end

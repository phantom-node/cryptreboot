# frozen_string_literal: true

module CryptReboot
  module CryptTab
    # Serialize crypttab entry into one line of text
    class EntrySerializer
      def call(entry)
        floptions = (entry.flags + serialize_options(entry.options)).join(',')
        [entry.target, entry.source, entry.key_file, floptions].join(' ')
      end

      private

      def serialize_options(options)
        options.map do |option, value|
          [option, value].join('=')
        end
      end
    end
  end
end

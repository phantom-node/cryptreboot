# frozen_string_literal: true

module CryptReboot
  module SafeTemp
    # Yield non-existing temporary file name located in a safe dir.
    # Afterwards the directory containing this file is deleted.
    class FileName
      def call(name = 'file')
        dir_provider.call do |dir|
          yield File.join(dir, name)
        end
      end

      private

      attr_reader :dir_provider

      def initialize(dir_provider: Directory.new)
        @dir_provider = dir_provider
      end
    end
  end
end

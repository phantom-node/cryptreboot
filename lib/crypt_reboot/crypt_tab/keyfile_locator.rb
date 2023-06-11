# frozen_string_literal: true

module CryptReboot
  module CryptTab
    # Return path of keyfile for given target
    class KeyfileLocator
      def call(target)
        File.join(base_dir, target + extension)
      end

      private

      attr_reader :base_dir, :extension

      def initialize(base_dir: '/cryptreboot', extension: '.key')
        @base_dir = base_dir
        @extension = extension
      end
    end
  end
end

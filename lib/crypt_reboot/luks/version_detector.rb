# frozen_string_literal: true

module CryptReboot
  module Luks
    # Return LUKS version or raise the exception if given file doesn't represent a valid LUKS device
    class VersionDetector
      Error              = Class.new StandardError
      NotLuks            = Class.new Error
      UnsupportedVersion = Class.new Error

      def call(headevice)
        version = supported_versions.find do |tested_version|
          checker.call(headevice, tested_version)
        end
        return version if version
        raise UnsupportedVersion if checker.call(headevice)

        raise NotLuks
      end

      private

      attr_reader :checker, :supported_versions

      def initialize(checker: Checker.new,
                     supported_versions: %w[LUKS2 LUKS1])
        @checker = checker
        @supported_versions = supported_versions
      end
    end
  end
end

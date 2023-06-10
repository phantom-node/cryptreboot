# frozen_string_literal: true

module CryptReboot
  module Luks
    # Return LUKS version or raise the exception if given file doesn't represent a valid LUKS device
    class VersionDetector
      Error              = Class.new StandardError
      NotLuks            = Class.new Error
      UnsupportedVersion = Class.new Error

      def call(headevice)
        detected_version = versions_to_check.find do |tested_version|
          check_version(headevice, tested_version)
        end
        raise NotLuks unless detected_version
        raise UnsupportedVersion if detected_version == :other

        detected_version
      end

      private

      def versions_to_check
        supported_versions + [:other]
      end

      def check_version(headevice, version)
        args = version == :other ? [] : ['--type', version]
        runner.call('isLuks', headevice, *args)
        true
      rescue run_exception
        false
      end

      attr_reader :runner, :run_exception, :supported_versions

      def initialize(verbose: false,
                     runner: CryptSetupRunner.new(verbose: verbose),
                     run_exception: CryptSetupRunner::ExitError,
                     supported_versions: %w[LUKS2 LUKS1])
        @runner = runner
        @run_exception = run_exception
        @supported_versions = supported_versions
      end
    end
  end
end

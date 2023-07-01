# frozen_string_literal: true

module CryptReboot
  # Perform the reboot or exit (doesn't return)
  class Rebooter
    def call(act = !Config.prepare_only)
      act ? runner.call : exiter.call
    end

    private

    attr_reader :runner, :exiter

    def initialize(runner: -> { Process.exec Config.reboot_path },
                   exiter: -> { exit 0 })
      @runner = runner
      @exiter = exiter
    end
  end
end

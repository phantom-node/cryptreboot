# frozen_string_literal: true

module CryptReboot
  # Perform the reboot or exit (doesn't return)
  class Rebooter
    def call(act = !Config.instance.prepare_only)
      act ? runner.call : exiter.call
    end

    private

    attr_reader :runner, :exiter

    def initialize(tool: Config.instance.reboot_path,
                   runner: -> { Process.exec(tool) },
                   exiter: -> { exit 0 })
      @runner = runner
      @exiter = exiter
    end
  end
end

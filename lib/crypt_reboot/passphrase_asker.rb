# frozen_string_literal: true

require 'io/console'

module CryptReboot
  # Ask user for passphrase and return it
  class PassphraseAsker
    def call(prompt)
      print prompt
      $stdin.noecho(&:gets).chomp
    ensure
      puts
    end
  end
end

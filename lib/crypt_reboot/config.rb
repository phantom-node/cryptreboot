# frozen_string_literal: true

require 'singleton'

module CryptReboot
  # Global configuration
  class Config
    include Singleton

    attr_accessor :verbose

    private

    def initialize
      @verbose = false
    end
  end
end

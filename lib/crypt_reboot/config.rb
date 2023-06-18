# frozen_string_literal: true

require 'singleton'

module CryptReboot
  # Global configuration
  class Config
    include Singleton

    attr_accessor :save_patch, :verbose

    private

    def initialize
      @save_patch = nil
      @verbose = false
    end
  end
end

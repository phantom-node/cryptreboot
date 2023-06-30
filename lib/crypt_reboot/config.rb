# frozen_string_literal: true

require 'singleton'

module CryptReboot
  # Global configuration singleton
  class Config < InstantiableConfig
    include Singleton
  end
end

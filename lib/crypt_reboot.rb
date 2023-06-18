# frozen_string_literal: true

begin
  require 'basic_loader'
rescue LoadError
  require 'zeitwerk'
  loader = Zeitwerk::Loader.for_gem
  loader.setup
end

# Main module
module CryptReboot
end

CryptReboot.const_set(:CODE_LOADER, loader)

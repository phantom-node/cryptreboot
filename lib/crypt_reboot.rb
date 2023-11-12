# frozen_string_literal: true

begin
  require 'basic_loader'
rescue LoadError => e
  raise if e.path != 'basic_loader'

  require 'zeitwerk'
  loader = Zeitwerk::Loader.for_gem
  loader.setup
end

# Main module
module CryptReboot
end

CryptReboot.const_set(:CODE_LOADER, loader)

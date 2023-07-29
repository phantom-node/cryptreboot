# frozen_string_literal: true

require_relative 'lib/crypt_reboot/version'

Gem::Specification.new do |spec|
  spec.name = 'crypt_reboot'
  spec.version = CryptReboot::VERSION
  spec.authors = ['Paweł Pokrywka']
  spec.email = ['pepawel@users.noreply.github.com']

  spec.summary = 'Linux utility for automatic and secure unlocking of encrypted disks on reboot'
  spec.homepage = 'https://phantomno.de/cryptreboot'
  spec.license = 'MIT'
  spec.required_ruby_version = '>= 2.7.0' # default version shipped with Ubuntu 20.04.5 LTS

  spec.metadata['homepage_uri'] = spec.homepage
  spec.metadata['source_code_uri'] = 'https://github.com/phantom-node/cryptreboot'
  spec.metadata['changelog_uri'] = 'https://github.com/phantom-node/cryptreboot/blob/master/CHANGELOG.md'
  spec.metadata['rubygems_mfa_required'] = 'true'

  spec.files = ['CHANGELOG.md', 'LICENSE.txt', 'README.md', 'lib/basic_loader.rb']
  spec.files += Dir.chdir(__dir__) do
    `git ls-files -z`.split("\x0").select do |f|
      f.match(%r{\A(?:lib|exe)/})
    end
  end
  spec.files -= ['lib/memory_locker.rb'] # do not include stub meant for development & testing

  spec.bindir = 'exe'
  spec.executables = spec.files.grep(%r{\Aexe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.add_dependency 'tty-command', '~> 0.10'
  spec.add_dependency 'tty-option', '~> 0.3'
end

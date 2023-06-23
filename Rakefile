# frozen_string_literal: true

require 'bundler/gem_tasks'
require 'rspec/core/rake_task'

RSpec::Core::RakeTask.new(:spec)

require 'rubocop/rake_task'

RuboCop::RakeTask.new

task default: %i[spec rubocop]

Rake::Task.define_task :update_loader do
  system('bin/update-loader') || raise('Updating loader failed')
end

Rake::Task.define_task :remove_loader do
  File.unlink('lib/basic_loader.rb')
end

Rake::Task[:build].enhance [:update_loader]
Rake::Task[:build].enhance do
  Rake::Task[:remove_loader].execute
end

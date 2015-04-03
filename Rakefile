#!/usr/bin/env rake
require 'rubygems'
require 'bundler/setup'

task :default => :spec

# Run spec
task :spec do
  system 'bundle exec rspec spec'
end

# Build gem
task :build do
  system 'gem build after_commit_queue.gemspec'
end

# Generate doc
begin
  require 'rdoc/task'
rescue LoadError
  require 'rdoc/rdoc'
  require 'rake/rdoctask'
  RDoc::Task = Rake::RDocTask
end

RDoc::Task.new(:rdoc) do |rdoc|
  rdoc.rdoc_dir = 'rdoc'
  rdoc.title    = 'AfterCommitQueue'
  rdoc.options << '--line-numbers'
  rdoc.rdoc_files.include('README.rdoc')
  rdoc.rdoc_files.include('lib/**/*.rb')
end

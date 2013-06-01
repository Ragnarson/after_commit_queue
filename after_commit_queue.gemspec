# encoding: utf-8
$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "after_commit_queue/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "after_commit_queue"
  s.version     = AfterCommitQueue::VERSION
  s.authors     = ["Grzegorz Kołodziejczyk", "Mariusz Pietrzyk"]
  s.email       = ["devs@shellycloud.com"]
  s.homepage    = "https://github.com/shellycloud/after_commit_queue"
  s.summary     = "after_commit queue"
  s.description = "Plugin for running methods on ActiveRecord models after record is committed"

  s.files = Dir["{app,config,db,lib}/**/*"] + ["MIT-LICENSE", "Rakefile", "README.md"]
  s.test_files = Dir["test/**/*"]

  s.add_dependency "rails", ">= 3.0"

  s.add_development_dependency "sqlite3"
end

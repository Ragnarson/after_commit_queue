plugin_test_dir = File.dirname(__FILE__)

require 'rubygems'
require 'bundler/setup'

require 'logger'
require 'active_record'

ActiveRecord::Base.logger = Logger.new(plugin_test_dir + '/debug.log')

require 'yaml'
require 'erb'
ActiveRecord::Base.configurations = YAML::load(ERB.new(IO.read(plugin_test_dir + '/db/database.yml')).result)
ActiveRecord::Base.establish_connection((ENV['DB'] ||= 'sqlite3mem').to_sym)
ActiveRecord::Migration.verbose = false

require 'combustion/database'
Combustion::Database.create_database(ActiveRecord::Base.configurations[ENV['DB']])
load(File.join(plugin_test_dir, 'db', 'schema.rb'))

require 'after_commit_queue'

begin
  require 'action_view'
rescue LoadError; end # action_view doesn't exist in Rails 4.0, but we need this for the tests to run with Rails 4.1

require 'action_controller'
require 'rspec/rails'

# Require proper state machine
begin
  require 'state_machine'
  state_machine = true
rescue LoadError
  require 'state_machines'
  state_machine = false
end

require 'database_cleaner'

if Rails::VERSION::MAJOR < 4
  require 'active_record/observer'
else
  if Rails::VERSION::MINOR >= 1 && state_machine
    # This is ugly patch, because state machine is no longer maintained...
    module StateMachine::Integrations::ActiveModel
      public :around_validation
    end
  end

  require 'rails/observers/activerecord/active_record'
end

require 'support/server'
require 'support/server_observer'

# Configure observers
Server.observers << ServerObserver
Server.instantiate_observers


RSpec.configure do |config|
  config.fixture_path               = "#{plugin_test_dir}/fixtures"
  config.infer_spec_type_from_file_location!

  config.after(:suite) do
    unless /sqlite/ === ENV['DB']
      Combustion::Database.drop_database(ActiveRecord::Base.configurations[ENV['DB']])
    end
  end
end

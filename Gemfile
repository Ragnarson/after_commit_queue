source "http://rubygems.org"

gemspec

platforms :jruby do
  gem 'activerecord-jdbcsqlite3-adapter', '>= 1.3.0.beta2'
  gem 'activerecord-jdbcmysql-adapter', '>= 1.3.0.beta2'
  gem 'jdbc-mysql'
  gem 'activerecord-jdbcpostgresql-adapter', '>= 1.3.0.beta2'
  gem 'jruby-openssl'
end

platforms :ruby do
  gem 'sqlite3'
  gem 'mysql2', (MYSQL2_VERSION if defined? MYSQL2_VERSION)
  gem 'pg'
end

gem 'appraisal'

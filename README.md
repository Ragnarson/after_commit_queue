# after_commit_queue
---

Rails plugin which allows to run callbacks after database transaction is committed.

### What problem does it solve ?

When using [state_machine](https://github.com/pluginaweek/state_machine) it's hard to run a callback on event after the transaction is committed.

after_commit_queue plugin addresses this problem.

### Installation

Add this to your Gemfile and run ```bundle install```

```ruby
gem 'after_commit_queue'
```

### Usage

Include AfterCommitQueue module in your ActiveRecord model and you're ready to go. When registering a hook with run_after_commit you can supply either a method symbol or a block. No parameter is supplied when using the block form.

```ruby
class Server < ActiveRecord::Base
  attr_accessor :started, :stopped

  # include plugin
  include AfterCommitQueue

  state_machine :state, :initial => :pending do
    after_transition :pending => :running, :do => :schedule_start
    after_transition :running => :turned_off, :do => :schedule_stop
    event(:start) { transition :pending => :running }
    event(:stop) { transition :running => :turned_off }
  end

  def schedule_start
    # Adds method to be run after transaction is committed
    run_after_commit(:start_server)
  end

  def schedule_stop
    run_after_commit do
      stop_server
    end
  end

  def start_server; @started = true end
  def stop_server; @stopped = true end
end
```

### Contributions

To fetch & test the library for development, do:

    $ git clone https://github.com/Ragnarson/after_commit_queue
    $ cd after_commit_queue
    $ bundle

#### Running tests

    # Before each test run, the database will be created and migrated automatically
    $ bundle exec rake test

If you want to contribute, please:

    * Fork the project.
    * Make your feature addition or bug fix.
    * Add tests for it. This is important so I don't break it in a future version unintentionally.
    * Send me a pull request on Github.

This project rocks and uses MIT-LICENSE.

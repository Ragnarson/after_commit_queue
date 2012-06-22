class Server < ActiveRecord::Base
  include AfterCommitQueue

  attr_accessor :started, :stopped

  state_machine :state, :initial => :pending do
    after_transition :pending => :running, :do => :schedule_start
    after_transition :running => :turned_off, :do => :schedule_stop
    event(:start) { transition :pending => :running }
    event(:stop) { transition :running => :turned_off }
  end

  def schedule_start
    run_after_commit(:start_server)
  end

  def schedule_stop
    run_after_commit(:stop_server)
  end

  def start_server; @started = true end
  def stop_server; @stopped = true end
end

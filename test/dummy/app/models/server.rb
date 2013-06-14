class Server < ActiveRecord::Base
  include AfterCommitQueue

  attr_accessor :started, :stopped, :meditating, :uninstalled

  state_machine :state, :initial => :pending do
    after_transition :pending => :running, :do => :schedule_start
    after_transition :running => :crashed, :do => :schedule_guru_meditation
    after_transition :running => :turned_off, :do => :schedule_stop

    event(:start) { transition :pending => :running }
    event(:stop) { transition :running => :turned_off }
    event(:crash) { transition :running => :crashed }
    event(:uninstall) { transition :turned_off => :uninstalled }
  end

  def schedule_start
    run_after_commit(:start_server)
  end

  def schedule_stop
    run_after_commit(:stop_server)
  end

  def schedule_guru_meditation
    run_after_commit do
      @meditating = true
    end
  end

  def start_server; @started = true end
  def stop_server; @stopped = true end
end

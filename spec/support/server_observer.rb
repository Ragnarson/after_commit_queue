class ServerObserver < ActiveRecord::Observer
  def after_transition_state_to_uninstalled(server, transition)
    server.run_after_commit { @uninstalled = true }
  end
end

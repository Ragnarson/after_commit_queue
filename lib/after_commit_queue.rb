module AfterCommitQueue
  extend ActiveSupport::Concern

  included do
    after_commit :_run_after_commit_queue
    after_rollback :_clear_after_commit_queue
  end

  # Public: Add method to after commit queue
  def run_after_commit(method = nil, &block)
    _after_commit_queue << Proc.new { self.send(method) } if method
    _after_commit_queue << block if block
    true
  end

  protected

  # Protected: Is called as after_commit callback
  # runs methods from the queue and clears the queue afterwards
  def _run_after_commit_queue
    _after_commit_queue.each do |action|
      self.instance_eval &action
    end
    @after_commit_queue.clear
  end

  # Protected: Return after commit queue
  # Returns: Array with methods to run
  def _after_commit_queue
    @after_commit_queue ||= []
  end

  def _clear_after_commit_queue
    _after_commit_queue.clear
  end
end

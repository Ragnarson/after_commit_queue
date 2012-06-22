require 'test_helper'

class AfterCommitQueueTest < ActiveSupport::TestCase
  def setup
    @server = Server.new
  end

  test "run after methods after transaction is committed" do
    assert !@server.started

    @server.transaction do
      @server.start!
      assert !@server.started
    end

    assert @server.started
  end

  test "clear queue after methods from are called" do
    @server.start!
    @server.started = false

    @server.stop!
    assert !@server.started
    assert @server.stopped
  end
end

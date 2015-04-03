require 'spec_helper'

describe 'AfterCommitQueue' do
  let(:server) { Server.create }

  it 'run methods after transaction is committed' do
    expect(server.started).to be_blank

    server.transaction do
      server.start!
      expect(server.started).to be_blank
    end

    expect(server.started).to be_truthy
  end

  it 'run blocks after transaction is committed' do
    server.start!
    expect(server.meditating).to be_blank

    server.transaction do
      server.crash!
      expect(server.meditating).to be_blank
    end

    expect(server.meditating).to be_truthy
  end

  it 'external observer changes state' do
    server.start!
    server.stop!
    expect(server.uninstalled).to be_blank

    server.transaction do
      server.uninstall!
      expect(server.uninstalled).to be_blank
    end

    expect(server.uninstalled).to be_truthy
  end

  it 'clear queue after methods from are called' do
    server.start!
    server.started = false

    server.stop!
    expect(server.started).to be_blank
    expect(server.stopped).to be_truthy
  end

  it 'clears queue after rollback' do
    expect(server.started).to be_blank

    Server.transaction do
      server.start!
      expect(server.started).to be_blank
      raise ActiveRecord::Rollback
    end

    expect(server.__send__(:_after_commit_queue).empty?).to be_truthy
    expect(server.started).to be_blank
  end

  it 'clears queue even when no callback was enqueued' do
    server.rolledback!(false)
  end
end

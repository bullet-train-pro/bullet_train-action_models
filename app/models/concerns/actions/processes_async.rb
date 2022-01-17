module Actions::ProcessesAsync
  extend ActiveSupport::Concern

  def dispatch
    self.sidekiq_jid = Actions::BackgroundActionWorker.perform_async(self.class.name, id)
    save
  end
end

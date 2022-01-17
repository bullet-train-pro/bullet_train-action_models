module Actions::ProcessesAsync
  extend ActiveSupport::Concern

  included do
  end

  module ClassMethods
  end

  def dispatch
    self.sidekiq_jid = Actions::BackgroundActionWorker.perform_async(self.class.name, id)
    save
  end
end

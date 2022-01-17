module Actions::SupportsScheduling
  extend ActiveSupport::Concern
  include Actions::ProcessesAsync

  def dispatch
    if scheduled_for.present?
      self.sidekiq_jid = Actions::ScheduledActionWorker.perform_at(scheduled_for, self.class.name, id)
      save
    else
      super
    end
  end
end

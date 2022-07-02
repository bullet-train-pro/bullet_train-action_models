module Actions::SupportsScheduling
  extend ActiveSupport::Concern
  include Actions::ProcessesAsync

  included do
    scope :scheduled, -> { where.not(scheduled_for: nil).where(started_at: nil, completed_at: nil) }
  end

  def dispatch
    if scheduled_for.present?
      self.sidekiq_jid = Actions::ScheduledActionWorker.perform_at(scheduled_for, self.class.name, id)
      save
    else
      super
    end
  end
end

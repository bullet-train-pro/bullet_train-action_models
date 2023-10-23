module Actions::ProcessesAsync
  extend ActiveSupport::Concern

  included do
    unless @_actions_base_included
      warn "ERROR: In #{name}: Actions::ProcessesAsync must be included _after_ Actions::Base, usually via Actions::TargetsOne or Actions::TargetsMany"
      exit 254
    end
  end

  def schedule_health_check
    return false if Rails.env.test?
    return false unless BulletTrain::ActionModels.health_check_worker
    Actions::BackgroundActionHealthCheckWorker.perform_at(health_check_frequency.from_now, self.class.name, id)
  end

  def sidekiq_queue
  end

  def dispatch
    self.sidekiq_jid = Actions::BackgroundActionWorker.set(sidekiq_queue ? {queue: sidekiq_queue} : {}).perform_async(self.class.name, id)
    save
  end
end

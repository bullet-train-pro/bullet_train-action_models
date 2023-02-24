module Actions::ProcessesAsync
  extend ActiveSupport::Concern

  included do
    unless @_actions_base_included
      warn "ERROR: In #{name}: Actions::ProcessesAsync must be included _after_ Actions::Base, usually via Actions::TargetsOne or Actions::TargetsMany"
      exit 254
    end
  end

  def dispatch
    self.sidekiq_jid = Actions::BackgroundActionWorker.perform_async(self.class.name, id)
    save
  end
end

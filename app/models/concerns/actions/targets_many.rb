module Actions::TargetsMany
  extend ActiveSupport::Concern
  include Actions::Base

  included do
  end

  module ClassMethods
  end

  def valid_targets
    raise "You need to implement `valid_targets` in this model."
  end

  def targeted
    target_all ? valid_targets : valid_targets.where(id: target_ids)
  end

  def set_target_count
    update(target_count: targeted.count)
  end

  def dispatch
    sidekiq_jid = if scheduled_for.present?
      Actions::ScheduledActionWorker.perform_at(scheduled_for, self.class.name, id)
    else
      Actions::BackgroundActionWorker.perform_async(self.class.name, id)
    end

    update(sidekiq_jid: sidekiq_jid)
  end

  # This is the batch-level control logic that iterates over the collection of targeted objects.
  def perform
    before_start

    targeted.find_each do |object|
      before_each
      perform_on_target(object)
      after_each
    rescue ActiveRecord::RecordNotFound
      after_each
      next
    end

    after_completion
  end

  def before_each
  end

  def after_each
  end

  def perform_on_target(object)
    raise "You need to implement `perform_on_target` in this model."
  end
end

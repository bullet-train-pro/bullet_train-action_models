module Actions::Base
  extend ActiveSupport::Concern

  # define relationships.
  included do
    belongs_to :created_by, class_name: "Membership", optional: true
    belongs_to :approved_by, class_name: "Membership", optional: true

    validates :created_by, scope: true
    validates :approved_by, scope: true

    after_commit :dispatch, on: [:create]
  end

  # define class methods.
  module ClassMethods
  end

  def valid_targets
    raise "You need to implement `valid_targets` in this model."
  end

  def valid_created_bys
    team.memberships
  end

  def valid_approved_bys
    team.memberships
  end

  def completion_percent
    return 0 unless target_count
    (performed_count.to_f / target_count.to_f) * 100.0
  end

  def targeted
    target_all ? valid_targets : valid_targets.where(id: target_ids)
  end

  def increment_performed_count
    # We do this over `increment!` because it triggers the callbacks that update the UI.
    update(performed_count: performed_count + 1)
  end

  def first?
    performed_count == 0
  end

  def last?
    # We have `- 1` here because we want to be able to check this _before_ the final `increment_performed_count`.
    performed_count >= (target_count - 1)
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
    # Calculate the
    update(started_at: Time.zone.now, target_count: targeted.count)

    targeted.find_each do |object|
      perform_on_target(object)
      increment_performed_count
    rescue ActiveRecord::RecordNotFound
      # If a record has gone missing since it was first targeted, just increment the count.
      increment_performed_count
      next
    end

    update(completed_at: Time.zone.now)

    # Usually we don't actually ask users if they want to keep the action receipt. Either developers choose to keep
    # them, or they choose to clean them up. Keeping them around provides an audit trail of actions users have taken.
    destroy unless keep_receipt?
  end

  def perform_on_target(object)
    raise "You need to implement `perform_on_target` in this model."
  end
end

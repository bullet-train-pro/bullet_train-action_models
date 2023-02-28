module Actions::TargetsMany
  extend ActiveSupport::Concern
  include Actions::Base

  # TODO Improve the localization of this.
  def label_string
    if target_all?
      "#{super} on all #{valid_targets.arel_table.name.titleize}"
    else
      "#{super} on #{target_ids.count} #{valid_targets.arel_table.name.titleize.pluralize(target_ids.count)}"
    end
  end

  def valid_targets
    raise "You need to implement `valid_targets` in this model."
  end

  def targeted
    target_all ? valid_targets.order(:id) : valid_targets.order(:id).where(id: target_ids)
  end

  # This is _not_ the same as targeted. This is for when we want a collection-esque look at what is in `target_ids`.
  def targets
    target_all ? [] : valid_targets.where(id: target_ids)
  end

  def calculate_target_count
    targeted.count
  end

  def page_size
    100
  end

  # TODO Do a health check that automatically restarts jobs that died in flight!

  def remaining_targets
    targeted.where("id > ?", last_completed_id).where.not(id: failed_ids)
  end

  def health_check_frequency
    30.seconds
  end

  def health_check_timeout
    45.seconds
  end

  def schedule_health_check
    Actions::BackgroundActionHealthCheckWorker.perform_at(health_check_frequency.from_now, self.class.name, id)
  end

  def first_dispatch?
    last_completed_id == 0
  end

  # This method is safe to call more than once, but not safe to run twice at the same time.
  def perform
    if first_dispatch?
      # We do this so we don't fail the health check right off the bat.
      touch
      schedule_health_check
      before_start
    end

    remaining_targets.limit(page_size).each do |object|
      before_each

      begin
        self.class.transaction do
          perform_on_target(object)
          update_column(:last_completed_id, object.id)
        end
      rescue => _
        failed_ids << object.id
        save
      end

      after_each
    rescue ActiveRecord::RecordNotFound
      after_each
      next
    end

    # If after we work through this page of items, if there are any items left after this, dispatch another job.
    if remaining_targets.any?
      dispatch
    else
      # Otherwise we're done.
      after_completion
    end
  end

  def before_each
  end

  def after_each
  end

  def perform_on_target(object)
    raise "You need to implement `perform_on_target` in this model."
  end
end

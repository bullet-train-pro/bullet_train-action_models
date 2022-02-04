module Actions::HasProgress
  extend ActiveSupport::Concern

  def callback_limit_rate
    1
  end

  def completion_percent
    return 0 unless target_count
    (performed_count.to_f / target_count.to_f) * 100.0
  end

  def increment_performed_count
    # We do this over `increment!` because it triggers the callbacks that update the UI.

    # E.g. If we're about to go to a count of 15 out of a 15, the remainder here will be zero, and we should trigger callbacks.
    if (performed_count + 1) % callback_limit_rate == 0
      update(performed_count: performed_count + 1)
    else
      increment!(:performed_count)
    end
  end

  def calculate_target_count
    unless defined?(super)
      raise "You need to define `calculate_target_count`. Did you forget to include `Actions::TargetsMany`?"
    end
  end

  def before_start
    update(target_count: calculate_target_count)
    super
  end

  def after_each
    increment_performed_count
    super
  end
end

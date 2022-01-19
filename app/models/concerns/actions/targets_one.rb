module Actions::TargetsOne
  extend ActiveSupport::Concern
  include Actions::Base

  def set_target_count
    raise "You need to define `set_target_count`."
  end

  # This is the batch-level control logic that iterates over the collection of targeted objects.
  def perform
    before_start
    perform_on_target(targeted)
    after_completion
  end
end

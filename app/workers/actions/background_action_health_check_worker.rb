class Actions::BackgroundActionHealthCheckWorker
  include Sidekiq::Worker

  def perform(*args)
    class_name, id = args
    action = class_name.constantize.find_by(id: id)

    # Skip everything if the job is actually completed. We're done here.
    return if action && action.completed_at.present?

    # If there is an error message then don't try to run the check again
    return if action && action.error_message.present?

    # If the action hasn't completed a unit of work within a specified period of time.
    if action.updated_at < action.health_check_timeout.ago
      # Restart the job.
      action.perform
    end

    # Re-schedule this health check.
    action.schedule_health_check
  end
end

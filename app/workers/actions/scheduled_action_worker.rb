class Actions::ScheduledActionWorker
  include Sidekiq::Worker

  def perform(*args)
    class_name, id = args
    begin
      class_name.constantize.find(id).perform
    rescue ActiveRecord::RecordNotFound => _
      # If the action model has disappeared, we'll assume they no longer wanted us to take this action.
    end
  end
end

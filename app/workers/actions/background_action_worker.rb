class Actions::BackgroundActionWorker
  include Sidekiq::Worker

  def perform(*args)
    class_name, id = args
    class_name.constantize.find(id).perform
  end
end

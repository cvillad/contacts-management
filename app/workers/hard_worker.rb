class HardWorker
  include Sidekiq::Worker

  def perform(*args)
  end
end

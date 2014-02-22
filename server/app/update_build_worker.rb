class UpdateBuildWorker
  include Sidekiq::Worker

  def perform(build)
    BuildFetcher.create(build).refresh
  end
end

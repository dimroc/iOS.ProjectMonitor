class UpdateBuildWorker
  include Sidekiq::Worker

  def self.perform(build)
    BuildFetcher.create(build).refresh
  end
end

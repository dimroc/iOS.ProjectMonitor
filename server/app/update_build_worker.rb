class UpdateBuildWorker
  include Sidekiq::Worker

  def perform(build)
    updated_build = BuildFetcher.create(build).fetch
    ParseClient.from_settings.update(updated_build)
  end
end

class UpdateBuildWorker
  include Sidekiq::Worker

  def perform(build)
    updated_build = BuildFetcher.create(build).fetch
    ParseClient.from_settings.save(updated_build)
  end
end

class UpdateBuildWorker
  include Sidekiq::Worker
  sidekiq_options unique: true, unique_args: :unique_args

  def self.unique_args(build)
    [build["objectId"]]
  end

  def perform(build)
    updated_build = BuildFetcher.create(build).fetch
    ParseClient.from_settings.update(updated_build)
  end
end

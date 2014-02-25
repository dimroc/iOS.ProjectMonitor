class UpdateBuildWorker
  include Sidekiq::Worker

  def perform(build_hash)
    build = ParseBuild.new build_hash
    updated_build = BuildFetcher.create(build).fetch
    client = ParseClient.from_settings
    client.update(updated_build)
    client.notify_build_failed(updated_build) if changed_to_failed?(build, updated_build)
  end

  private

  def changed_to_failed?(original, updated)
    !original.status.include?("failed") && updated.status.include?("failed")
  end
end

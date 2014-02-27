class UpdateBuildWorker
  include Sidekiq::Worker

  def perform(build_hash)
    build = ParseBuild.new build_hash
    updated_build = BuildFetcher.create(build).fetch
    merged_build = ParseBuild.merge(build, updated_build)

    client = ParseClient.from_settings
    client.update(merged_build)
    client.notify_build_failed(merged_build) if changed_to_failed?(build, updated_build)
  end

  private

  def changed_to_failed?(original, updated)
    !original.status.include?("failed") && updated.status.include?("failed")
  end
end

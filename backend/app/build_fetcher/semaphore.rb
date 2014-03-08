class BuildFetcher::Semaphore < BuildFetcher
  def parse(content)
    semaphore = JSON.parse content

    ParseBuild.new({
      project: semaphore["project_name"],
      url: semaphore["branch_status_url"],
      type: "Semaphore",
      status: semaphore["result"],
      branch: semaphore["branch_name"],
      startedAt: semaphore["started_at"],
      finishedAt: semaphore["finished_at"],

      commitSha: semaphore["commit"]["id"],
      commitEmail: semaphore["commit"]["author_email"],
      commitMessage: semaphore["commit"]["message"],
      commitAuthor: semaphore["commit"]["author_name"]
    })
  end

  def fetch
    updated_build = parse(retrieve_from_url(build.url))
    updated_build.objectId = build.objectId
    updated_build.user = build.user
    updated_build
  end
end

class BuildFetcher::TravisPro < BuildFetcher
  def parse(content)
    build = content["build"]
    commit = content["commit"]
    ParseBuild.new({
      type: build_type,
      status: build["state"],
      startedAt: build["started_at"],
      finishedAt: build["finished_at"],
      branch: commit["branch"],
      commitSha: commit["sha"],
      commitEmail: commit["author_email"],
      commitMessage: commit["message"],
      commitAuthor: commit["author_name"]
    })
  end

  def fetch
    repo_info = retrieve_repo
    details = retrieve_build_details(repo_info)

    updated_build = parse(details)
    updated_build.objectId = build.objectId
    updated_build.user = build.user
    updated_build
  rescue ForbiddenError
    puts "Forbidden: #{build}"
    updated_build = ParseBuild.new build.dup
    updated_build.isInvalid = true
    updated_build
  end

  def base_url
    "https://api.travis-ci.com"
  end

  def build_type
    self.class.name.demodulize
  end

  private

  def retrieve_repo
    url = "#{base_url}/repos/#{build.project}?access_token=#{build.accessToken}"
    JSON.parse retrieve_from_url(url, headers)
  end

  def retrieve_build_details(repo_info)
    build_id = repo_info["repo"]["last_build_id"]
    url = "#{base_url}/builds/#{build_id}?access_token=#{build.accessToken}"
    JSON.parse retrieve_from_url(url, headers)
  end

  def headers
    {
      "User-Agent" => "iOSProjectMonitor-server/1.0",
      "Accept" => "application/vnd.travis-ci.2+json"
    }
  end
end

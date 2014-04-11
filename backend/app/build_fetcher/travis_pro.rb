class BuildFetcher::TravisPro < BuildFetcher
  def parse(content)
    ParseBuild.new({
      type: build_type,
      status: translate_result(content["result"]),
      startedAt: content["started_at"],
      finishedAt: content["finished_at"],
      branch: content["branch"],
      commitSha: content["commit"],
      commitEmail: content["author_email"],
      commitMessage: content["message"],
      commitAuthor: content["author_name"]
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
    updated_build = build.dup
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

  def translate_result(travis_result)
    case travis_result
    when 0
      "passed"
    when 1
      "failed"
    when 2
      "pending"
    else
      "undetermined"
    end
  end

  def retrieve_repo
    url = "#{base_url}/repos/#{build.project}?access_token=#{build.accessToken}"
    JSON.parse retrieve_from_url(url)
  end

  def retrieve_build_details(repo_info)
    build_id = repo_info["last_build_id"]
    url = "#{base_url}/builds/#{build_id}?access_token=#{build.accessToken}"
    JSON.parse retrieve_from_url(url)
  end
end

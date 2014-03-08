class BuildFetcher::PublicTravis < BuildFetcher::PrivateTravis
  def base_url
    "https://api.travis-ci.org"
  end
end

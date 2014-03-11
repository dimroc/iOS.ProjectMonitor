class BuildFetcher::Travis < BuildFetcher::TravisPro
  def base_url
    "https://api.travis-ci.org"
  end
end

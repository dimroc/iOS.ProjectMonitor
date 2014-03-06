class BuildFetcher
  attr_reader :build

  def self.create(build)
    "BuildFetcher::#{build["type"].gsub("Build","")}".constantize.new(build)
  end

  def initialize(build)
    @build = Hashie::Mash.new build
  end

  def fetch
    raise NotImplementedError
  end

  def retrieve_from_url(url)
    code, body = CachedHttpParty.get(url)

    if code < 300
      body
    else
      raise StandardError, "Error connecting to <#{url}?. Status: #{code} Message: #{body}"
    end
  end
end

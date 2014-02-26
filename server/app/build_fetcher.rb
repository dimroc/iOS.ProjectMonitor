class BuildFetcher
  attr_reader :build

  def self.create(build)
    "BuildFetcher::#{build["type"].gsub("Build","")}".constantize.new(build)
  end

  def initialize(build)
    @build = Hashie::Mash.new build
  end

  def fetch
    updated_build = parse(retrieve_from_url)
    updated_build.objectId = build.objectId
    updated_build.user = build.user
    updated_build
  end

  private

  def parse(content)
    raise NotImplementedError
  end

  def retrieve_from_url
    code, body = CachedHttpParty.get(build.url)

    if code < 300
      body
    else
      raise StandardError, "Error connecting to <#{build.url}?. Status: #{code} Message: #{body}"
    end
  end
end

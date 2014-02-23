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
    updated_build
  end

  private

  def parse(content)
    raise NotImplementedError
  end

  def retrieve_from_url
    response = HTTParty.get(build.url)
    if response.code < 300
      response.body
    else
      raise StandardError, "Error connecting to <#{build.url}?. Status: #{response.code} Message: #{response.message} #{response}"
    end
  end
end

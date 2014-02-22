class BuildFetcher
  attr_reader :build

  def self.create(build)
    "BuildFetcher::#{build["type"].gsub("Build","")}".constantize.new(build)
  end

  def initialize(build)
    @build = Hashie::Mash.new build
  end

  def refresh
    save parse(fetch)
  end

  private

  def parse(content)
    raise NotImplementedError
  end

  def fetch
    response = HTTParty.get(build.url)
    if response.code < 300
      response.body
    else
      raise StandardError, "Error connecting to <#{build.url}?. Status: #{response.code} Message: #{response.message} #{response}"
    end
  end

  def save(updated_build)
    puts "saving to parse: #{updated_build}"
  end
end

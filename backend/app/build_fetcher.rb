class BuildFetcher
  class ForbiddenError < StandardError; end;

  attr_reader :build

  def self.create(build)
    fetcher_name = build["type"]
    "BuildFetcher::#{fetcher_name}".constantize.new(build)
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
    elsif code == 403
      raise ForbiddenError, body
    else
      raise StandardError, "Error connecting to <#{url}?. Status: #{code} Message: #{body}"
    end
  end
end

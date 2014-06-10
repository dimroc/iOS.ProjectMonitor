class BuildFetcher
  class ForbiddenError < StandardError; end;
  class NotFoundError < StandardError; end;

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

  def retrieve_from_url(url, headers = {})
    code, body = CachedHttpParty.get(url, headers)
    raise StandardError, "Unable to retrieve from URL probably due to locked redis mutex. url: #{url}" unless code

    if code < 300
      body
    elsif code == 403
      raise ForbiddenError, body
    elsif code == 404
      raise NotFoundError, body
    else
      raise StandardError, "Error connecting to <#{url}?. Status: #{code} Message: #{body}"
    end
  end
end

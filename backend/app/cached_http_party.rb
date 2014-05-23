class CachedHttpParty
  class << self
    def get(url, headers = {})
      rval = nil

      semaphore(url).lock do
        rval = cache.fetch(url, expires_in: 1.minute) do
          response = HTTParty.get(url, headers: headers)
          # Can't serialize HTTParty response because it has a Proc.
          [response.code, response.body]
        end
      end

      rval
    end

    # Ensures only one thread pays the expense of retrieving the url via a distributed mutex.
    # All subsequent threads will get the cached value.
    def semaphore(url)
      Redis::Semaphore.new(url, :connection => Redis.current)
    end

    def cache
      ActiveSupport::Cache.lookup_store(Settings.cache_store.to_sym)
    end
  end
end

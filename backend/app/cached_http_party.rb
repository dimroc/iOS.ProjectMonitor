class CachedHttpParty
  class << self
    def get(url, headers = {})
      rval = nil

      Sidekiq.redis do |redis|
        semaphore(url, redis).lock(20) do
          rval = cache.fetch(url, expires_in: 1.minute) do
            response = HTTParty.get(url, headers: headers, timeout: 30)
            # Can't serialize HTTParty response because it has a Proc.
            [response.code, response.body]
          end
        end
      end

      rval
    end

    # Ensures only one thread pays the expense of retrieving the url via a distributed mutex.
    # All subsequent threads will get the cached value.
    def semaphore(url, redis)
      Redis::Semaphore.new(url, :redis => redis, :stale_client_timeout => 120)
    end

    def cache
      ActiveSupport::Cache.lookup_store(Settings.cache_store.to_sym)
    end
  end
end

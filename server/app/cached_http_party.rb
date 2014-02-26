class CachedHttpParty
  def self.get(url, store = Settings.cache_store.to_sym)
    cache = ActiveSupport::Cache.lookup_store(store)
    cache.fetch(url, expires_in: 1.minute) do
      response = HTTParty.get(url)
      # Can't serialize HTTParty response because it has a Proc.
      [response.code, response.body]
    end
  end
end

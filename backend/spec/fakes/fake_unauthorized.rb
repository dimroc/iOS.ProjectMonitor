class FakeUnauthorized
  def self.call(env)
    [
      401,
      { 'Content-Type' => 'application/json' },
      [{"error"=>"unauthorized"}.to_json]
    ]
  end
end

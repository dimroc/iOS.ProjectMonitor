class FakeError
  def self.call(env)
    [
      503,
      { 'Content-Type' => 'application/json' },
      [{ "error" => "server error" }.to_json]
    ]
  end
end
